<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="classes.ConectaBD" %>

<%
int ag = Integer.parseInt(request.getParameter("agencia"));
int cc = Integer.parseInt(request.getParameter("conta"));
DecimalFormat df = new DecimalFormat("#,##0.00");
SimpleDateFormat sd = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"); 
try
{
	// conecta com BD
	ConectaBD cbd = new ConectaBD();
	Connection conn = cbd.Conectar();
	String Sql = "select nome, saldo from cliente where agencia = " 
					+ ag + " and conta = " + cc;
   	Statement st = conn.createStatement();
   	// gera resultado da consulta
   	ResultSet rs = st.executeQuery(Sql);
   	if(rs.next())
   	{
   	 	String nome_cli = rs.getString("nome");
   	 	Float saldo_cli = rs.getFloat("saldo");
   	 	rs.close(); 
	 	st.close();
   	   	Sql = "select * from contacorrente where agencia = " 
	 	+ ag + " and conta = " + cc 
	 	+ " order by data_ocorrencia";
   	   	st = conn.createStatement();
   	   	rs = st.executeQuery(Sql);
   	 	  	 	
%>
<!DOCTYPE html>
<html>
<head> 
<title>Simulador de Caixa Eletr�nico</title> 
<link rel="stylesheet" type="text/css" href="estilos.css">
</head>
<body> 
<div>Simulador de Caixa Eletr�nico</div>
<div>Extrato de Conta Corrente</div>
<br>
<div>Ag�ncia: <%=ag%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Conta: <%=cc%></div>
<div>Cliente: <%=nome_cli%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Saldo: <%=df.format(saldo_cli)%></div>
<table>
<tr><th>Data</th><th>Valor</th><th>Ocorr�ncia</th></tr>
<%
int alt = 0; // vari�vel de controle de altern�nica de cor de fundo de linha da tabela
// lista todas as ocorr�ncias de uma mesma ag�ncia e conta
	  	while(rs.next())
	   	{
	  		if(alt == 0) {%>
	  			<tr bgcolor=snow>
	  		<%  alt = 1;
	  		}
	  		else
	  		{%>
	  			<tr bgcolor=ivory>
	  		<% alt = 0;
	  		}
	  		%><td><%=sd.format(rs.getDate("data_ocorrencia"))%></td>
	  		<td style="text-align: right;"><%=df.format(rs.getFloat("valor"))%></td>
	  		<td>
	  		<%if(rs.getInt("tipo") == 1) {%>
	  			Dep�sito
	  		<%}
			if(rs.getInt("tipo") == 2) {%>
	  			Saque
	  		<%}
	  		if(rs.getInt("tipo") == 3) {%>
	  			Pagamento
	  		<%}%>
	  		</td></tr>
	   		<%
	   	}
   	}
   	else
   	{
   		out.println("Extrato inexistente - Ag�ncia e Conta n�o encontrado");
   	}

// Fecha conex�es
  	rs.close(); 
	st.close(); 
	conn.close();
}
catch(Exception e)
{
   out.println("Ocorreu uma exce��o - " + e.getMessage());
}

%>
</table>
<form action="index.jsp" method="get">
	<input type=submit value="Voltar">
</form>
</body>
</html>
