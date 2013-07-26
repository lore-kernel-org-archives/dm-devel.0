From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm-cache: dirty state of blocks in writethrough mode
Date: Fri, 26 Jul 2013 13:14:01 +0200
Message-ID: <51F259F9.1090107@redhat.com>
References: <C91EDD5251EDF44CB434B1039B0DEEB82A8D0762@SACEXCMBX02-PRD.hq.netapp.com>
	<51EE8470.6070302@redhat.com> <20130724102452.GA6963@gmail.com>
	<51F00977.7060802@redhat.com> <20130724130220.GC6963@gmail.com>
	<51F101CB.20900@redhat.com> <20130726024546.GA8707@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130726024546.GA8707@gmail.com>
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


On 07/26/2013 04:45 AM, Kumar amit mehta wrote:
> On Thu, Jul 25, 2013 at 12:45:31PM +0200, Heinz Mauelshagen wrote:
>> You can set up a mirrored metadata device to be resilient against
>> SSD failures.
> Okay
>
>> Plus you can take metadata snapshots at arbitrary points in time;
>> see the targets kernel documentation in thin-provisioning.txt for this
>> and the recent thin_dump support metadata snapshots  in the rawhide
>> device-mapper-persistent-data package.
>>
> So these feature is already upstream and also in fedora 20, but not in
> Red Hat 6.4 yet ?

No, it's planned for RHEL7.

>
>> Either is subject to future LVM2 support and isn't supported as yet.
> So, if LVM2 doesn't support it as of now, Any idea if EVMS or any other
> volume Managers consume these features?

None that I'm aware of.

Use dmsetup for early testing.

We'll support it in LVM2 later in the year.

Heinz

>
> !!amit
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
