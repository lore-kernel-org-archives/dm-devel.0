From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Re: back-ported dm-cache not forwarding read-ahead bios
	to origin
Date: Tue, 21 Jul 2015 10:56:05 +0100
Message-ID: <CAM2wQBucP2rmVNv=+Aq2VG+3gCH529ngyYOoen7PEbmt88Em2w@mail.gmail.com>
References: <CAM2wQBv43BGGhe+NHOEAz+usppL6CcR-2m_ratKNKR65GB+XVA@mail.gmail.com>
	<20150720172226.GA27018@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150720172226.GA27018@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com, Mauelshagen@redhat.com
List-Id: dm-devel.ids

> Upstream backports to RHEL6 are tricky because it doesn't have
> upstream's latest block changes.  Care must be taken during the
> backport.  I could easily see someone less aware of the pitfalls
> producing a buggy kernel that cause corruption like you've reported.
>
> The last dm-cache backport to RHEL6 was kernel-2.6.32-528.el6.
> That backport sync'd dm-cache changes through upstream Linux 3.19.
>
> I'm not going to put any time to this report.  Your best bet is to
> rebase to the >= 528.el6 kernel and go from there (this translates to
> the forthcoming RHEL6.7 kernel as the first publicly available release
> with the changes in question).

Thanks Mike, had I known that there was a back-port planned for 6.7 I wouldn't
have bothered back-porting it myself... I tried to look for an existing
back-port for CentOS a few months back but didn't find anything. Just to teach
myself a lesson, if I had asked on this list whether a back-port was planned,
would I have gotten a response, or such information could not have been
disclosed?

Because our product is based on CentOS, it might take some time for dm-cache
to become available through CentOS 6.7. So for now I'll have to continue using
my broken version in order to integrate it with our product. Any help
appreciated

--
Thanos Makatos
