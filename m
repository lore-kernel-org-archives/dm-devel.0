From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Multipath not rebuilding correctly on reboot
Date: Tue, 12 Feb 2008 09:42:08 -0800
Message-ID: <110b17190802120942u70700712oa38aabfba4a0172c@mail.gmail.com>
References: <2F1F44D192D1284BAA298E48C1B2A4F90234F16E@exchmail03.ncogroup.com>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F1C3@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F1C3@exchmail03.ncogroup.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Could you also share your multipath.conf file.

Regards,
Pradipmaya.

2008/2/12 Greene, Rick <rick.greene@ncogroup.com>:
> I never saw any response on this, though a side comment on my other
> thread did get one query that I tried to direct to here, so I figured
> I'd repost and see if anyone had any ideas.
>
> Re-attaching the original docs as well.
>
> Thanks in advance,
> Rick
>
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Greene, Rick
> Sent: Thursday, January 31, 2008 3:20 PM
> To: device-mapper development
> Subject: [dm-devel] Multipath not rebuilding correctly on reboot
>
> Now that I seem to have multipath and my XP 1024 working together, I've
> found a new issue.  Someone recently had a similar thread going, but I
> saw no ultimate resolution.
>
> My problem is that when I reboot my server, the multipath configuration
> is not coming back the way it was before.  I moved the two external
> tools I use to find the UID into /etc (they had bin in /usr/bin and
> /sbin), updated the multipath.conf file (and one of the scripts) to
> reflect this, but odd things are still happening.
>
> Attached is initial_view.txt, which shows what multipath is coming up
> with when I do the commands shown (the bulk of the file is multipath -v3
> output, but at the bottom of the file is a multipath -ll output as
> well).  It (seems to) correctly shows that I have 4 disks, each visible
> via two separate paths.
>
> After I reboot, however, I get different results.  Once it showed 4
> paths for mpath0, and 2 paths for mpath1, 2, and 3.  Next time it
> correctly showed mpath0, mpath1, and mpath3, but didn't show mpath2 at
> all.  On the next attempt I got everything correct, and the very next
> one only showed mpath0 and mpath1.
>
> The post_reboot.txt file shows the contents of the /var/log/boot.log
> file and the output of the dmesg command, along with the "multipath -ll"
> view from the most recent reboot.
>
> I then manually did a "multipath -v2" and the missing two paths then
> came back.  The file manual_run.txt shows those results plus the updated
> "multipath -ll".
>
> Do I need to just make my own /etc/init.d script to do a "multipath -v2"
> at the end of booting to make sure it all gets covered, along with the
> requisite LVM & mount commands to get the VG that is on these disks
> working right?
>
> Thanks in advance,
> Rick
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
