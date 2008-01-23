From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Documenting Device Mapper Targets?
Date: Wed, 23 Jan 2008 23:07:03 +0000
Message-ID: <20080123230703.GU8075@agk.fab.redhat.com>
References: <4797B277.30103@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4797B277.30103@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: slevine@redhat.com
Cc: "Michael H. Smith" <mhideo@redhat.com>, mwhitehe@redhat.com, dm-devel@redhat.com, cluster-list@redhat.com, David Teigland <teigland@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 23, 2008 at 03:32:39PM -0600, Steven Levine wrote:
> Matthew Whitehead wrote:
> This includes the format of the 'dmsetup table' data for all the above.
> Documentation for the table formats is very scarce! An typically cryptic
> example is this:
> 0 71014400 multipath 0 0 2 1 round-robin 0 2 1 66:128 1000 65:64 1000
> round-robin 0 2 1 8:0 1000 67:192 1000
 
Those are internal structures that are designed to be (1) easy for the
computer to process; (2) extendible.  Sysadmins should use the
'multipath' tool to decode it.

What I would like however, is an additional dmsetup command line option that
would decode each of the table lines into a human-readable format.
Something like:  dmsetup table --expanded

[Details: libdevmapper will acquire a per-target-type built-in plug-in,
one function of which will be to do this decoding.]

> You should show how to create a snapshot device using device-mapper. I have
> only started to dabble with this one because documentation is nonexistant.
 
This one *is* documented in the tree:
Documentation/device-mapper/snapshot.txt.

Alasdair
-- 
agk@redhat.com
