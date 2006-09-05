From: "bart brooks" <bart_brooks@hotmail.com>
Subject: Re: SCSI Sense patch
Date: Tue, 05 Sep 2006 15:56:50 +0000
Message-ID: <BAY114-F483ED5326C22601EF09069D300@phx.gbl>
References: <20060905151005.GM13859@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060905151005.GM13859@agk.surrey.redhat.com>
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

Hi Alasdair,

I take it you are referring to the addition of “bi_error” to the bio data 
structure.
Any idea when an alternate solution will be available, is it still in the 
discussion phase ?

Thanks
  Bart Brooks



>From: Alasdair G Kergon <agk@redhat.com>
>Reply-To: device-mapper development <dm-devel@redhat.com>
>To: device-mapper development <dm-devel@redhat.com>
>Subject: Re: [dm-devel] SCSI Sense patch
>Date: Tue, 5 Sep 2006 16:10:05 +0100
>MIME-Version: 1.0
>Received: from hormel.redhat.com ([209.132.177.30]) by 
>bay0-mc8-f11.bay0.hotmail.com with Microsoft SMTPSVC(6.0.3790.2444); Tue, 5 
>Sep 2006 08:10:25 -0700
>Received: from listman.util.phx.redhat.com (listman.util.phx.redhat.com 
>[10.8.4.110])by hormel.redhat.com (Postfix) with ESMTPid 54EFF73268; Tue,  
>5 Sep 2006 11:10:25 -0400 (EDT)
>Received: from int-mx1.corp.redhat.com 
>(int-mx1.corp.redhat.com[172.16.52.254])by listman.util.phx.redhat.com 
>(8.13.1/8.13.1) with ESMTP idk85FAN1m020225 for 
><dm-devel@listman.util.phx.redhat.com>;Tue, 5 Sep 2006 11:10:23 -0400
>Received: from pobox.surrey.redhat.com (pobox.surrey.redhat.com 
>[172.16.10.17])by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with 
>ESMTP idk85FA9vF015603for <dm-devel@int-mx1.corp.redhat.com>; Tue, 5 Sep 
>2006 11:10:22 -0400
>Received: from agk.surrey.redhat.com (agk.surrey.redhat.com 
>[172.16.10.74])by pobox.surrey.redhat.com (8.12.11.20060308/8.12.11) with 
>ESMTP idk85FA5f6012975for <dm-devel@redhat.com>; Tue, 5 Sep 2006 16:10:05 
>+0100
>Received: from agk by agk.surrey.redhat.com with local (Exim 4.34)id 
>1GKcYv-0008IM-M2for dm-devel@redhat.com; Tue, 05 Sep 2006 16:10:05 +0100
>X-Message-Info: LsUYwwHHNt3660MmjhEvYg2f34OAemlKtU9j2Z7TuGo=
>Mail-Followup-To: device-mapper development <dm-devel@redhat.com>
>References: 
><1156791189.26413.8.camel@cutter><BAY114-F20C6936AC3F7E04C0C7C429D300@phx.gbl>
>User-Agent: Mutt/1.4.1i
>X-loop: dm-devel@redhat.com
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
>X-OriginalArrivalTime: 05 Sep 2006 15:10:25.0736 (UTC) 
>FILETIME=[6A6B5480:01C6D0FD]
>
>On Tue, Sep 05, 2006 at 01:59:51PM +0000, bart brooks wrote:
> > I have been using for sometime Axboe?s SCSI sense data patches, which 
>make
> > available the sense data in the bio end_io path and the dm-mpath?s
> > hw_handler. They work very nice.
> > When will the show up in RHEL 4, in update 5 or later?
>
>Unfortunately not because (1) upstream has decided not to use them but
>to work towards an alternative way of achieving the same goal; and
>(2) the patches involve a change to an important data structure that
>might cause pre-compiled modules unconnected with device-mapper to cause
>corruption.
>
>Alasdair
>--
>agk@redhat.com
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
