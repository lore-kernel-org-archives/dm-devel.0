Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D2E19046C
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130830; cv=none; b=pIwN8KqyOuB0zfyVY30TT44ium4IsEPPiVHvfyVFwcMAxxWVfzApWvfwQCtF70K9N4PCmvrWSRjsALVElDeh6CY8B2XxQJUmOSXZ+YDsAPFnqbeWCpVTl5ia+7ETuAdpHZrmtNOcNWfLEX5pcLASFI9ytLve9SfaeO85mQL0wso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130830; c=relaxed/simple;
	bh=U1N23bLhZ8Q/cU5ry7kDQKb2YMEjjn8f+5ivTrR3AC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFY5wdq4CorhGo6dHg0Ufls48qMcE1AzwTl56Wa2Ecr9UWI3TowbaMwV8idBAqgoy1BO4nUoh9U0nnCe3pCetXLNZxUZTMD5r4/jlHtRuJ1Lrd8peQ7OLZN3WCyxoP0fD5WNAA92Wi/gTZ9xSd8Ll/zeaqZbL+xO0r9k1rwx7AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vq3/AJaL; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vq3/AJaL"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a7a9a369055so111378066b.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130827; x=1723735627; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MbGYQx5ZtiHFGUqnXY26+MQ5M/tCOwsS5KJP9foxsPc=;
        b=Vq3/AJaLEZjD6QEG4vFrVWn9Z0zmWlYqJondC6wNj7aYy0YCvX6597aw73rzTvzNgw
         kHqTF9rKwAZKki4RV7AHKKIjQf9crEnl5WSOcFZeVEqTxpufPspBA8v4K3LI7hVlyqdJ
         Y5XPKNlrvkTHR31qGYO16tTUQj+YwAwFbQGi58CwZQyLzObbDjH+6RIuLWvvDsmCZaK+
         dyVAgGi9NhKAN/E5mMh0SoDnIv5Gpnqnk5qF9RpntWqItj05SN8tfbiVafGMQC5CTQvz
         zpZMM1Mslq9q8oxvE90Ze1FJ6e+fXsJxD9/F3NLKGw8Jyhx/7VW9mtzzTWoBlvgKqpp4
         OtSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130827; x=1723735627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbGYQx5ZtiHFGUqnXY26+MQ5M/tCOwsS5KJP9foxsPc=;
        b=cakHynpL70trcDzPOFlUCydNb8qd5iqpPSCIxZSNUF/1dOoPhe6f5e6gFj3YHfxJEb
         2usc6L5p6Z5c2lA3DURgHqV7YrsVj6wBJQSja724hiCXJ93AIqvBY0dtwkYXyjqNDTGp
         uVsmZQCXwex0dLhcrj9FLVcaEhwEfabo4unJiQmgbXiCLzCpO9H8to7VVk9Y87fUZlLs
         RJ0QDboIZBs08Zvxb4FmuisgZqzyqVy9sdTIRHm8/vo0P+OQpb45bNIt8n8WrjZ/YbZW
         y3yE9QyZaUuAQxvsBniDWL+rSa3lHGzhU2477kFuQpbLl0sC/k46M6HnERlj8WYBQDQ5
         vu+A==
X-Gm-Message-State: AOJu0Ywz9TOU56AWp285Z51VM8Dto5d0vemDN0PLuVndUfI1dNVLtI2z
	A9UGHZ3D2ELvCgTrWfAP6pb2LedImT5NqvSWPfF6lZmlj/WsC++yS6WyXXr2dSk=
X-Google-Smtp-Source: AGHT+IFQG4pWsuy0786BrZTGLzSZYuMyeW/PZ84swBaDiSvf0BUEpRjVYJwzPoLaRc6Ue/VU8NV3DA==
X-Received: by 2002:a17:907:f14b:b0:a7a:b385:37c5 with SMTP id a640c23a62f3a-a8090c66787mr147639166b.17.1723130827119;
        Thu, 08 Aug 2024 08:27:07 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7de8afba6asm607006766b.66.2024.08.08.08.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:06 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 32/41] libmultipath: remove struct and union names in cciss.h
Date: Thu,  8 Aug 2024 17:26:11 +0200
Message-ID: <20240808152620.93965-33-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only the typedef names are used in the rest of the code, so
we don't need these struct names.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/cciss.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/libmultipath/checkers/cciss.h b/libmultipath/checkers/cciss.h
index bdb1184..19450c2 100644
--- a/libmultipath/checkers/cciss.h
+++ b/libmultipath/checkers/cciss.h
@@ -42,7 +42,7 @@
 #pragma pack(1)
 
 //Command List Structure
-typedef union _SCSI3Addr_struct {
+typedef union {
 	struct {
 		BYTE Dev;
 		BYTE Bus:6;
@@ -61,27 +61,27 @@ typedef union _SCSI3Addr_struct {
 	} LogUnit;
 } SCSI3Addr_struct;
 
-typedef struct _PhysDevAddr_struct {
+typedef struct {
 	DWORD             TargetId:24;
 	DWORD             Bus:6;
 	DWORD             Mode:2;
 	SCSI3Addr_struct  Target[2]; //2 level target device addr
 } PhysDevAddr_struct;
 
-typedef struct _LogDevAddr_struct {
+typedef struct {
 	DWORD            VolId:30;
 	DWORD            Mode:2;
 	BYTE             reserved[4];
 } LogDevAddr_struct;
 
-typedef union _LUNAddr_struct {
+typedef union {
 	BYTE               LunAddrBytes[8];
 	SCSI3Addr_struct   SCSI3Lun[4];
 	PhysDevAddr_struct PhysDev;
 	LogDevAddr_struct  LogDev;
 } LUNAddr_struct;
 
-typedef struct _RequestBlock_struct {
+typedef struct {
 	BYTE   CDBLen;
 	struct {
 		BYTE Type:3;
@@ -92,7 +92,7 @@ typedef struct _RequestBlock_struct {
 	BYTE   CDB[16];
 } RequestBlock_struct;
 
-typedef union _MoreErrInfo_struct{
+typedef union {
 	struct {
 		BYTE  Reserved[3];
 		BYTE  Type;
@@ -106,7 +106,7 @@ typedef union _MoreErrInfo_struct{
 	} Invalid_Cmd;
 } MoreErrInfo_struct;
 
-typedef struct _ErrorInfo_struct {
+typedef struct {
 	BYTE               ScsiStatus;
 	BYTE               SenseLen;
 	HWORD              CommandStatus;
@@ -117,7 +117,7 @@ typedef struct _ErrorInfo_struct {
 
 #pragma pack()
 
-typedef struct _IOCTL_Command_struct {
+typedef struct {
 	LUNAddr_struct		LUN_info;
 	RequestBlock_struct	Request;
 	ErrorInfo_struct	error_info;
@@ -125,7 +125,7 @@ typedef struct _IOCTL_Command_struct {
 	BYTE			*buf;
 } IOCTL_Command_struct;
 
-typedef struct _LogvolInfo_struct{
+typedef struct {
 	__u32   LunID;
 	int     num_opens;  /* number of opens on the logical volume */
 	int     num_parts;  /* number of partitions configured on logvol */
-- 
2.46.0

