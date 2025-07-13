// lib/pages/subscription/SubscriptionWastePage.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';
import '../../bloc/planbloc/plan_bloc.dart';
import '../../bloc/planbloc/plan_event.dart';
import '../../bloc/planbloc/plan_state.dart';
import 'package:provider/provider.dart';
import '../../core/controller/authController.dart';
import '../../core/model/subscriptionPlanModel.dart';

class SubscriptionWastePage extends StatelessWidget {
  const SubscriptionWastePage({super.key});
  @override Widget build(BuildContext ctx) {
    final role = ctx.read<AuthController>().user?.role;
    if (role == 'provider') {
      return BlocProvider(
        create: (_) => PlanBloc(SubscriptionService())..add(LoadPlans()),
        child: const _ProviderPlanView(),
      );
    } else {
      // 기존 langganan user view atau redirect
      return Navigator.pushReplacementNamed(ctx, '/mySubscriptions') as Widget;
    }
  }
}

class _ProviderPlanView extends StatelessWidget {
  const _ProviderPlanView();

  void _showForm(BuildContext ctx, {SubscriptionPlan? plan}) {
    final nameCtl = TextEditingController(text: plan?.name);
    final descCtl = TextEditingController(text: plan?.description);
    final priceCtl= TextEditingController(text: plan?.price.toString());
    String freq = plan?.frequency ?? 'daily';

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(plan == null ? 'Tambah Paket' : 'Edit Paket'),
        content: SingleChildScrollView(
          child: Column(children: [
            TextField(controller: nameCtl, decoration: InputDecoration(labelText:'Name')),
            TextField(controller: descCtl, decoration: InputDecoration(labelText:'Desc')),
            TextField(controller: priceCtl, decoration: InputDecoration(labelText:'Price'), keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: freq,
              items: ['daily','weekly','monthly'].map((f) => DropdownMenuItem(value:f, child:Text(f))).toList(),
              onChanged: (v)=>freq=v!,
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(onPressed: (){
            final p = SubscriptionPlan(
              planId: plan?.planId ?? 0,
              name: nameCtl.text,
              description: descCtl.text,
              price: double.parse(priceCtl.text),
              frequency: freq,
            );
            final bloc = ctx.read<PlanBloc>();
            if (plan == null) bloc.add(AddPlan(p));
            else bloc.add(UpdatePlanEvt(p));
            Navigator.pop(ctx);
          }, child: const Text('Simpan')),
        ],
      ),
    );
  }

  @override Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Paket'), backgroundColor: Colors.green[700]),
      body: BlocBuilder<PlanBloc, PlanState>(
        builder: (ctx, state) {
          if (state is PlanLoading) return const Center(child:CircularProgressIndicator());
          if (state is PlanFailure) return Center(child: Text('Error: ${state.error}'));
          if (state is PlanLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.plans.length,
              itemBuilder: (c,i){
                final plan = state.plans[i];
                return Card(
                  margin: const EdgeInsets.only(bottom:12),
                  child: ListTile(
                    title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Rp${plan.price.toStringAsFixed(0)} / ${plan.frequency}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: ()=>_showForm(ctx, plan: plan),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: ()=>ctx.read<PlanBloc>().add(DeletePlanEvt(plan.planId)),
                      ),
                    ]),
                  ),
                );
              }
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: ()=>_showForm(ctx),
        child: const Icon(Icons.add),
      ),
    );
  }
}
