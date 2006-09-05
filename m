From: "bart brooks" <bart_brooks@hotmail.com>
Subject: Re: SCSI Sense patch
Date: Tue, 05 Sep 2006 21:12:39 +0000
Message-ID: <BAY114-F3773B8BFBF0D1B588213C99D300@phx.gbl>
References: <44FDB64E.7020301@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44FDB64E.7020301@cs.wisc.edu>
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

Hi Mike,

Thanks for responding to my question
I took a look at the patches and see what you mean.
It would be a nightmare to maintain error code mapping in the scsi-core for 
each unique type of device that produces UA/sense data.

Bart


>From: Mike Christie <michaelc@cs.wisc.edu>
>Reply-To: device-mapper development <dm-devel@redhat.com>
>To: device-mapper development <dm-devel@redhat.com>
>Subject: Re: [dm-devel] SCSI Sense patch
>Date: Tue, 05 Sep 2006 12:39:26 -0500
>MIME-Version: 1.0
>Received: from hormel.redhat.com ([209.132.177.30]) by 
>bay0-mc6-f16.bay0.hotmail.com with Microsoft SMTPSVC(6.0.3790.2444); Tue, 5 
>Sep 2006 10:39:45 -0700
>Received: from listman.util.phx.redhat.com (listman.util.phx.redhat.com 
>[10.8.4.110])by hormel.redhat.com (Postfix) with ESMTPid C936273117; Tue,  
>5 Sep 2006 13:39:42 -0400 (EDT)
>Received: from int-mx1.corp.redhat.com 
>(int-mx1.corp.redhat.com[172.16.52.254])by listman.util.phx.redhat.com 
>(8.13.1/8.13.1) with ESMTP idk85HdfWF000464 for 
><dm-devel@listman.util.phx.redhat.com>;Tue, 5 Sep 2006 13:39:41 -0400
>Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])by 
>int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP 
>idk85HdfiK029876for <dm-devel@redhat.com>; Tue, 5 Sep 2006 13:39:41 -0400
>Received: from sabe.cs.wisc.edu (sabe.cs.wisc.edu [128.105.6.20])by 
>mx3.redhat.com (8.13.1/8.13.1) with ESMTP id k85HdWOT001383for 
><dm-devel@redhat.com>; Tue, 5 Sep 2006 13:39:33 -0400
>Received: from [192.168.0.7] (CPE-70-92-133-61.mn.res.rr.com 
>[70.92.133.61])(authenticated bits=0)by sabe.cs.wisc.edu (8.13.6/8.13.6) 
>with ESMTP id k85HdVd6024654(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA 
>bits=256 verify=NO)for <dm-devel@redhat.com>; Tue, 5 Sep 2006 12:39:32 
>-0500
>X-Message-Info: LsUYwwHHNt3660MmjhEvYg2f34OAemlKtU9j2Z7TuGo=
>User-Agent: Thunderbird 1.5 (X11/20060313)
>References: <BAY114-F483ED5326C22601EF09069D300@phx.gbl>
>X-Enigmail-Version: 0.94.0.0
>X-RedHat-Spam-Score: 0 X-loop: dm-devel@redhat.com
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
>X-OriginalArrivalTime: 05 Sep 2006 17:39:45.0634 (UTC) 
>FILETIME=[46EF4420:01C6D112]
>
>bart brooks wrote:
> > Hi Alasdair,
> >
> > I take it you are referring to the addition of “bi_error” to the bio
> > data structure.
> > Any idea when an alternate solution will be available, is it still in
> > the discussion phase ?
> >
>
>I did two possible alternatives when trying to think of a way around
>KABI. You can find them here
>
>http://www.cs.wisc.edu/~michaelc/block/dm/rhel4/
>
>I am not pushing either approach right now since one is a crazy ugly
>hack (u3-bio-sense/) that I do not want to maintain or try to completely
>test for something like RHEL. The other possibility (u3-blkerr) is nicer
>but needs to be fixed up for some cases and needs lots of testing. The
>latter approach is also a little hacky since I had to work around the
>KABI restrictions but I do not think it is as evil as the u3-bio-sense
>approach.
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
