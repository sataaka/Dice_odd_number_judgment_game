<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Random" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // パラメータの取得
    String diceStr = request.getParameter("dice");
    String reset = request.getParameter("reset");
    //合計値の取得
    int total = 0;
    boolean isError = false;
    boolean result = true;
    
    // セッションを取得または新規作成
    HttpSession set = request.getSession(true);
    
   
    if (reset != null) {
        // リセットボタンが押された場合、セッションのデータをクリア
        session.removeAttribute("total");
        session.removeAttribute("diceRolls");
    } else {
        // セッションからtotalを取得し、nullの場合は0をセット
        Integer sessionTotal = (Integer) session.getAttribute("total");
        if (sessionTotal == null) {
            sessionTotal = 0;
        }
        total = sessionTotal;
        
        // セッションからサイコロの目のリストを取得し、nullの場合は新規作成
        List<Integer> diceRolls = (List<Integer>) session.getAttribute("diceRolls");
        if (diceRolls == null) {
            diceRolls = new ArrayList<>();
        }
        
        // 入力検証とサイコロの目の生成
        if (diceStr != null && !diceStr.isEmpty()) {
            try {
                int dice = Integer.parseInt(diceStr);
                Random random = new Random();
                for (int i = 0; i < dice; i++) {
                    int roll = random.nextInt(6) + 1; // サイコロの目は1から6まで
                    total += roll;
                    diceRolls.add(roll);
                }
                // セッションスコープに合計とサイコロの目のリストを保存
                session.setAttribute("total", total);
                session.setAttribute("diceRolls", diceRolls);
            } catch (NumberFormatException e) {
                isError = true;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Java基礎 - 課題演習問題4</title>
</head>
<body>
    <h1>java基礎 - 演習問題4</h1>
    <p>サイコロゲーム</p>
    <div>出た目の合計が偶数の場合はあなたの勝ちです。</div>
    <%
        if (isError) {
    %>
            <div>数値の形式が正しくありません。</div>
    <%
        } else if (diceStr != null && !diceStr.isEmpty() && reset == null) {
    %>
            <div><%= diceStr %>回振った結果の合計は<%= total %>です。</div>
     <%
	     if(total % 2 == 0){
     %>
     		<div>偶数なので、あなたの勝ちです</div>
     <%
         }else{
     %>
     		<div>奇数なので、あなたの負けです</div>
     <%
         }
     %>
            <div>サイコロの目の結果: 
                <%
                    List<Integer> diceRolls = (List<Integer>) session.getAttribute("diceRolls");
                    for (int roll : diceRolls) {
                        out.print(roll + " ");
                    }
                %>
            </div>
    <%
        }
    %>
    <div>
        <form action="javaBasic4.jsp" method="post">
            振る回数: <input type="text" name="dice"><br>
            <button type="submit">開始</button>
            <button type="submit" name="reset" value="true">リセット</button>
        </form>
    </div>
</body>
</html>
