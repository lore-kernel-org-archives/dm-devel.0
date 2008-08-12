From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Tue, 12 Aug 2008 12:07:24 -0700
Message-ID: <200808121207.25140.phillips@phunq.net>
References: <20080804171242V.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080804171242V.fujita.tomonori@lab.ntt.co.jp>
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
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Monday 04 August 2008 01:22, FUJITA Tomonori wrote:
> Note that the code is still in a very early stage. There are lots of
> TODO items:
> 
> ...
> 
> - applying a delta to in a atomic manner

This is not necessary because of the way the ddsnap replication
algorithm works.  A delta is always written to the downstream origin,
and nothing else accesses the downstream origin while that is taking
place.

Regards,

Daniel
