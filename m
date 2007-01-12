From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: DS4000 with multipath-tools 0.4.5
Date: Fri, 12 Jan 2007 15:01:48 -0600
Message-ID: <20070112210148.GA7441@ether.msp.redhat.com>
References: <20070111083430.GD11203@kernel.dk>
	<OFFB7A5A44.FA4CC8A7-ON85257260.004E61B6-85257260.004F7AA6@mohegansun.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OFFB7A5A44.FA4CC8A7-ON85257260.004E61B6-85257260.004F7AA6@mohegansun.com>
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

On Thu, Jan 11, 2007 at 09:28:07AM -0500, TGrozev@mohegansun.com wrote:
>    Hi, all!
> 
>    I've been trying to get dm-multipath working with an IBM DS4800
>    (previously IBM FAStT) for some time now, and I'm still having some
>    issues. The main problem is the lack of a suitable prioritizer. I've read
>    that the recommended prioritizer for DS4000 is pp_tpc, which, however,
>    appears in 0.4.7. I'm kinda stuck with 0.4.5, though, since I'm using
>    RHEL4 (2.6.9) with RedHat Cluster.
>    Is there a way to use pp_tpc with 0.4.5? I'd really like to use
>    dm-multipath instead of the IBM RDAC multipath.

The path prioritizer is simply a external program that is called by
dm-multipath. All you need  to do is compile and install pp_tpc, and add a
configuration for your device that uses it to /etc/multipath.conf

 
>    Thanks much,
>    Tenyo
>    **************************************************************************************************
>    The information contained in this message may be privileged and
>    confidential and protected from disclosure. If the reader of this message
>    is not the intended recipient, or an employee or agent responsible for
>    delivering this message to the intended recipient, you are hereby notified
>    that any dissemination, distribution, or copy of this communication is
>    strictly prohibited. If you have received this communication in error,
>    please notify us immediately by replying to the message and deleting it
>    from your computer.
>    **************************************************************************************************

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
