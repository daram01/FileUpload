<%@page import="utils.JSFunction"%>
<%@page import="java.io.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String saveDirectory = application.getRealPath("/Uploads");
	String saveFilename = request.getParameter("sName"); // 업로드날짜와 시간 정보로 되어있는 파일 이름.
	String originalFilename = request.getParameter("oName"); // 실제로 저장되어있는 파일 이름.
	// 다운로드 받을 때 실제 저장명으로 되어있지 않으면 어떤 파일을 다운받은 건지 알 수 없기 때문에 실제로 저장된 파일명으로 다운로드될 수 있도록 매개변수로 받아 변수에 저장한다.
	
	try{
		File file = new File(saveDirectory, saveFilename); // File(경로, 파일명)
		InputStream inStream = new FileInputStream(file); // 해당 파일을 찾아 입력 스트림을 만든다.
		
		// 한글 파일명 깨짐 방지
		String client = request.getHeader("User-Agent"); // 클라이언트가 요청을 하면 헤더부분에 브라우저 정보도 같이 넘어오기 때문에 getHeader로 브라우저 정보를 받는다.
		if(client.indexOf("WOW64") == -1){
			originalFilename = new String(originalFilename.getBytes("UTF-8"),"ISO-8859-1");
		}else{
			originalFilename = new String(originalFilename.getBytes("KSC5601"), "ISO-8859-1");
		}
		
		// 파일 다운로드용 응답 헤더 설정
		response.reset(); // 응답 헤더 초기화. 이전에 다운로드 했을 때의 정보가 남아있을 수 있기 때문에 리셋.
		response.setContentType("application/octet-stream"); // 8비트 단위의 데이터
		response.setHeader("Content-Disposition", "attachment; filename=\"" + originalFilename + "\""); // 다운로드될 때 보여질 이름
		response.setHeader("Content-Length", "" + file.length()); // 다운로드 될 때 파일의 크기를 알려주는 것
		
		// 출력 스트림 초기화
		out.clear();
		
		// response 내장 객체로부터 새로운 출력 스트림 생성
		OutputStream outStream = response.getOutputStream(); // 서버-> 클라이언트 쪽으로 
		
		// 출력 스트림에 파일 내용 출력
		byte b[] = new byte[(int)file.length()];
		int readBuffer = 0;
		while ( (readBuffer = inStream.read(b)) > 0 ) {
			outStream.write(b, 0, readBuffer);
		}
		
		// 사용후에는 항상 입-출력 스트림을 닫아야 한다.
		inStream.close();
		outStream.close();
	
	}
	catch(FileNotFoundException e){
		JSFunction.alertBack("파일을 찾을 수 없습니다.", out);
	}catch(Exception e){
		JSFunction.alertBack("예외가 발생하였습니다.", out);
	}
%>