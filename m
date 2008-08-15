From: "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Fri, 15 Aug 2008 22:53:11 +0900
Message-ID: <c4a7c9420808150653s1ef637d7ia4cac8312ecd7377@mail.gmail.com>
References: <Pine.LNX.4.64.0808061453470.19728@devserv.devel.redhat.com>
	<Pine.LNX.4.64.0808111740520.14722@hs20-bc2-1.build.redhat.com>
	<20080812083440U.fujita.tomonori@lab.ntt.co.jp>
	<200808131714.09311.phillips@phunq.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200808131714.09311.phillips@phunq.net>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

Hello folks,

2008/8/14 Daniel Phillips <phillips@phunq.net>:
> On Monday 11 August 2008 16:34, FUJITA Tomonori wrote:
>> On Mon, 11 Aug 2008 18:12:08 -0400 (EDT) Mikulas Patocka <mpatocka@redhat.com> wrote:
>> > So use different format --- we in RedHat plan redesigning it too. One of
>> > the needed features is "rolling snapshots" --- i.e. you take snapshot
>
> Matt Dillon's Hammer for BSD has rolling snapshots, effectively
> infinite snapshots on a per-fsync basis.  I strongly suggest that you
> think about rustling up some engineers to join a porting team, both
> Red Hat and NTT.

I'm a developer of NILFS, a Linux log-structured filesystem with the
rolling snapshots
(we call it continous snapshots);  NILFS can take inifinite snapshots
every few seconds
or on a per-fsync basis.  ( It is available from  http://www.nilfs.org/  )

Though it works fine and is maintained for the recent kernels, it's
too complicated
due to its LFS nature (as Tomonori pointed out).  So, I am happy if we
can realize
continuous snapshotting filesystem much simpler on nicely supported dm or block
layer features.

We also have to keep in mind that filesystem development requires much
more energy
than usual projects.   It seems that a lot of development energy is
dispersed around  filesystems especially for Linux.   I'm still
working on NILFS to make it simple enough,
but I am also glad to cooperate with other engineers if other FS
people or Red Hat
people hope for that.

With regards,
Ryusuke Konishi
