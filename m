From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [RFC] DM Snapshot scalability - Common snap store
	approach
Date: Fri, 13 Oct 2006 13:30:32 -0400
Message-ID: <170fa0d20610131030g15d27462x821114cc19726a36@mail.gmail.com>
References: <452A3B1A0200000B0001CA9C@lucius.provo.novell.com>
	<452A40850200000B0001CAE7@lucius.provo.novell.com>
	<452A409C0200000B0001CAE9@lucius.provo.novell.com>
	<452A40AC0200000B0001CAEB@lucius.provo.novell.com>
	<452A41140200000B0001CAED@lucius.provo.novell.com>
	<452A413B0200000B0001CAF6@lucius.provo.novell.com>
	<452A414F0200000B0001CAF8@lucius.provo.novell.com>
	<452A41610200000B0001CAFA@lucius.provo.novell.com>
	<452A417D0200000B0001CAFC@lucius.provo.novell.com>
	<452A5625.E9E2.000B.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <452A5625.E9E2.000B.0@novell.com>
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

On 10/9/06, Vijai Babu Madhavan <MVijai@novell.com> wrote:

> Quick summary
> =========
>
> Various approaches that are being considered/prototyped to solve the
> scalability problem with
> DM snapshots are described here. Currently, I like the 2.d approach
> (using a single cow device
> for all snapshots of an origin, with a combination of exception
> stores). If you don't want to
> read about other approaches, jump there directly. I would like to know
> about other ways
> to solve this problem, and comments about these approaches.

A shared exception store was included as part of the cluster snapshot
prototype that Daniel Phillips worked on some time ago:
http://sources.redhat.com/cluster/csnap/

See section "1.3  Multiple Snapshots" and "5 Server Implementation
details" in csnap.ps.  And csnap.c in the csnap.0.0.1.tgz

This code is quite cluster oriented but it does provide a good amount
of detail on how one might implement a shared exception store.  I
kernel-based solution could come later...

It would be _very_ nice to improve the current dm-snapshot with shared
exceptions; I for one am eager to see continued
discussion/implementation of this.

Mike
