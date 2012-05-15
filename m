From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: /dev/mapper/<dm_name> symlink not being created
Date: Tue, 15 May 2012 15:07:05 +0100
Message-ID: <20120515140705.GA19147@agk-dp.fab.redhat.com>
References: <CACmkXc5fQCF78UW1_tEruAiuWL_EgODLt87=ZD-d_f2zT-GPeA@mail.gmail.com>
	<CACmkXc5cEhvdBgHzbNW13cFcoj83LjFea=qwZOq5UUq5vpwdAw@mail.gmail.com>
	<4FB10BE7.8090602@redhat.com>
	<CACmkXc75Sp1itjaNvsU-y8Jq51V34feZuzxRFPqWxC1ASdo22g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACmkXc75Sp1itjaNvsU-y8Jq51V34feZuzxRFPqWxC1ASdo22g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

dmsetup and udev have the functionality needed to do this in a race-free
manner, but it's necessarily complicated and takes a while to get your head
around it.  You'll need to use the dmsetup commands/options for udev cookies
described in the man page.

Alasdair
