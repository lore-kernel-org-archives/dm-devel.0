From: Martin George <marting@netapp.com>
Subject: Re: Root device multipathed host freeze with the latest
 upstream multipath-tools package
Date: Wed, 30 Jan 2008 20:50:33 +0530
Message-ID: <47A095C1.2070801@netapp.com>
References: <20080123.152850.74751092.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080123.152850.74751092.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: "Sarraf, Ritesh" <Ritesh.Sarraf@netapp.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Kiyoshi,

I made the suggested changes to the script (removing 'sleep' & using an 
empty while loop instead) and it worked fine. Preliminary IO runs with 
FCP path faults also look good.

Thanks,
-Martin

Kiyoshi Ueda wrote:
> Hi Martin,
> 
> On Wed, 23 Jan 2008 16:28:16 +0530, Martin George wrote:
>  > Kiyoshi Ueda wrote:
>  > > Hi Martin,
>  > >
>  > > Thank you for your testing.
>  > > Please see my comments below.
>  > >
>  > > On Tue, 22 Jan 2008 21:56:13 +0530, "Sarraf, Ritesh" wrote:
>  > >  > Hi Kiyoshi,
>  > >  >
>  > >  > I took the latest upstream multipath-tools package (Jan 15, 
> 2008) and
>  > >  > installed it on my RHEL 5.1 host to verify the libprio fix. To 
> simulate
>  > >  > the FCP path faults, I ran your script (as attached in the mail) 
> which
>  > >  > alternately offlined/onlined the corresponding SCSI paths of the 
> root dm
>  > >  > device in the syfs. Listing my observations below:
>  > >  >
>  > >  > 1) The freeze was still reproducible. On checking the sysrq 
> dumps (as
>  > >  > attached), I could see it was the script itself i.e. test.sh 
> which seems
>  > >  > to have stalled on the exec () system call perhaps waiting for inode
>  > >  > write out for updated access time (the script resides on my root dm
>  > >  > device itself). As suggested by you in the bugzilla, I remounted the
>  > >  > root device using the noatime option and then reran the script - 
> I have
>  > >  > not hit the freeze yet. Is this the expected behavior?
>  > >
>  > > As for your script, it is the expected behavior.
>  > > I found that you added some sleep commands to my original script
>  > > posted by the following email.
>  > >
>  > >     http://marc.info/?l=dm-devel&m=119465024621783&w=2 
> <http://marc.info/?l=dm-devel&m=119465024621783&w=2>
>  > > <http://marc.info/?l=dm-devel&m=119465024621783&w=2 
> <http://marc.info/?l=dm-devel&m=119465024621783&w=2>>
>  > >
>  > > sleep is not shell build-in command, so need to access the root device.
>  > > I guess that is the reason of the freeze.
>  >
>  > So does that mean you should never access the root partition in such a
>  > scenario? What about utilities like syslogd which may access the root to
>  > log messages? There could be many such utilities for that matter which
>  > accesses the root and all would have to be stopped.
> 
> No.
> Generally you can access the root.
> But you can't in your single-threaded test script.
> 
> On your testing scenario, only your script would online/offline paths
> for the root like this:
>     while true; do
>         <offline all paths>
>         sleep
>         <online all paths>
>         sleep
>     done
> 
> So if your script accesses to the root after it offlines all paths,
> it is freezed and nobody will online the paths.
> So you must avoid your script to be freezed.
> Other utilities accessing to the root don't matter.
> 
> I guess that your script is freezed at the sleep after the offline.
> 
> Thanks,
> Kiyoshi Ueda
> 
