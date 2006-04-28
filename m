From: "bart brooks" <bart_brooks@hotmail.com>
Subject: RE: Multipath and SCSI_STATUS
Date: Fri, 28 Apr 2006 11:55:18 +0000
Message-ID: <BAY114-F25A9FB7596F8CF7B8608159DB20@phx.gbl>
References: <BAY114-F14D9914F1A5FF57AFCA4A79DBD0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BAY114-F14D9914F1A5FF57AFCA4A79DBD0@phx.gbl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I found the status patch done by Lars Marowsky-Bree and Jen Axboe-
The patch did the job

Bart



>From: "bart brooks" <bart_brooks@hotmail.com>
>Reply-To: device-mapper development <dm-devel@redhat.com>
>To: dm-devel@redhat.com
>Subject: [dm-devel] Multipath and SCSI_STATUS Date: Thu, 27 Apr 2006 
>17:26:31 +0000
>MIME-Version: 1.0
>X-Originating-IP: [207.114.252.60]
>X-Originating-Email: [bart_brooks@hotmail.com]
>X-Sender: bart_brooks@hotmail.com
>Received: from hormel.redhat.com ([209.132.177.30]) by 
>bay0-mc7-f4.bay0.hotmail.com with Microsoft SMTPSVC(6.0.3790.1830); Thu, 27 
>Apr 2006 11:14:48 -0700
>Received: from listman.util.phx.redhat.com (listman.util.phx.redhat.com 
>[10.8.4.110])by hormel.redhat.com (Postfix) with ESMTPid 2FB427303A; Thu, 
>27 Apr 2006 14:14:55 -0400 (EDT)
>Received: from int-mx1.corp.redhat.com 
>(int-mx1.corp.redhat.com[172.16.52.254])by listman.util.phx.redhat.com 
>(8.13.1/8.13.1) with ESMTP idk3RIErvf022770 for 
><dm-devel@listman.util.phx.redhat.com>;Thu, 27 Apr 2006 14:14:53 -0400
>Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])by 
>int-mx1.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP 
>idk3RIErVq017686for <dm-devel@redhat.com>; Thu, 27 Apr 2006 14:14:53 -0400
>Received: from hotmail.com (bay114-f14.bay114.hotmail.com [65.54.169.24])by 
>mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP idk3RIEpsj010342for 
><dm-devel@redhat.com>; Thu, 27 Apr 2006 14:14:51 -0400
>Received: from mail pickup service by hotmail.com with Microsoft 
>SMTPSVC;Thu, 27 Apr 2006 10:26:34 -0700
>Received: from 65.54.169.200 by by114fd.bay114.hotmail.msn.com with 
>HTTP;Thu, 27 Apr 2006 17:26:31 GMT
>X-Message-Info: yilqo4+6kc4XcNS2ZEgQBdLQQp2gBJkV7ucUa7dMiy4=
>X-OriginalArrivalTime: 27 Apr 2006 17:26:34.0050 
>(UTC)FILETIME=[BAFFE220:01C66A1F]
>X-RedHat-Blacklist-Warning: Relay 65.54.169.24 is blacklisted by a RBL 
>system
>X-RedHat-Spam-Score: 0.762 X-loop: dm-devel@redhat.com
>X-BeenThere: dm-devel@redhat.com
>X-Mailman-Version: 2.1.5
>Precedence: junk
>List-Id: device-mapper development <dm-devel.redhat.com>
>List-Unsubscribe: 
><https://www.redhat.com/mailman/listinfo/dm-devel>,<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
>List-Archive: <https://www.redhat.com/archives/dm-devel>
>List-Post: <mailto:dm-devel@redhat.com>
>List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
>List-Subscribe: 
><https://www.redhat.com/mailman/listinfo/dm-devel>,<mailto:dm-devel-request@redhat.com?subject=subscribe>
>Errors-To: dm-devel-bounces@redhat.com
>Return-Path: dm-devel-bounces@redhat.com
>
>I have a question related to SCSI_STATUS and multipath, which I hope 
>someone can answer.
>Will a  hardware_handler get called at its error function when a Unit 
>Attention occurs on a multipath device, will the Sense Status be available.
>
>I’m running RHEL 4 update 2
>
>Thanks in advance,
>Bart
>
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
