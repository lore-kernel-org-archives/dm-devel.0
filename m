From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Mon, 5 Jan 2009 18:51:45 +0000
Message-ID: <20090105185145.GA20013@agk.fab.redhat.com>
References: <492C91DF.7040507@redhat.com>
	<ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
	<49467039.6060801@redhat.com> <20081220001305.GA8574@us.ibm.com>
	<49502F7E.9040300@redhat.com> <20081223180228.GA24831@us.ibm.com>
	<49622ADB.7040200@redhat.com>
	<20090105162435.GB18452@us.ibm.com> <4962450C.20507@redhat.com>
	<20090105184408.GA20412@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090105184408.GA20412@us.ibm.com>
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

On Mon, Jan 05, 2009 at 10:44:08AM -0800, malahal@us.ibm.com wrote:
> What we need is changes to LVM "--partial" code path where it can create
> volumes read-only or read-write based on what is available instead of
> blindly doing read-only.

This functionality changed recently - try the latest release.

Alasdair
-- 
agk@redhat.com
