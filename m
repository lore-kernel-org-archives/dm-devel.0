From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 20/20] dm-crypt: sort writes
Date: Tue, 21 Aug 2012 09:39:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1208210938250.31912@file.rdu.redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<55cef4f342136f3b57d7449b88b4eb1fc6fc7569.1345477953.git.mbroz@redhat.com>
	<20120821105748.GB29183@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120821105748.GB29183@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Tue, 21 Aug 2012, Alasdair G Kergon wrote:

> On Tue, Aug 21, 2012 at 11:09:31AM +0200, Mikulas Patocka wrote:
> > In theory the sorting should be performed by the underlying disk scheduler,
> > however, in practice the disk scheduler accepts and sorts only 128 requests.
> > In order to sort more requests, we need to implement our own sorting.
>  
> Why 128?  Isn't this nr_requests?
> (I thought we discussed this before.)
> 
> Alasdair

Yes, that's nr_requests. The user can raise it, but the default is 128.

Mikulas
