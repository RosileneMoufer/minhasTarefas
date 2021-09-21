# minhasTarefas
Aplicação em Flutter integrada ao Firebase.

<p>É possível inserir uma tarefa, deletar, ler e alterar estado da tarefa, que pode ser "fazer", "fazendo" e "feito".</p> 

<p> O que a aplicação contém:</p>
- CRUD com Firebase; </ br>
- Provider com ChangeNotifierProvider para ser possível notificar todos os ouvintes sobre a alteração de algum elemento. Esta parte foi implementada para fins didáticos, pois a exibição e atualização dos dados está sendo feita com StreamBuilder, o que facilita a atualização e exibição em tempo real de qualquer alteração feita no banco de dados, que no caso é o Firebase.
