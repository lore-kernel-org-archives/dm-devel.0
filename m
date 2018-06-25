From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-crypt] dm-integrity standalone - lack of metadata
Date: Mon, 25 Jun 2018 14:05:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806251403500.26995@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180624095348.GA819@nn.nn>
	<c2d97932-69f0-20aa-e66a-fd6be5b5eda3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c2d97932-69f0-20aa-e66a-fd6be5b5eda3@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-crypt@saout.de, Harald Braumann <harry@unheit.net>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Sun, 24 Jun 2018, Milan Broz wrote:

> (added cc to dm-devel annd Mikulas)
> 
> Hi,
> 
> On 06/24/2018 11:53 AM, Harald Braumann wrote:
> > Hi!
> > 
> > I'm using the dm-integrity target standalone with crc32c for component
> > devices of a RAID. I don't use journaling, because the perfomance hit
> > is too big and I don't really need it in that case.
> > 
> > I want to automatically activate these targets using udev
> > rules (see below). However, the superblock lacks some crucial
> > information:
> 
> 
> yes, I agree. The reason is that dm-integrity was in the first
> place designed for authenticated encryption (to store auth tags).
> Then additional metadata ia stored in LUKS2 header.
> 
> For the rest I just I have not enough energy (and real-world use cases)
> to convince Mikulas that we need attributes below in superblock (as the dm-integrity
> code is written mostly by him).

You can write whatever you want to the end of the superblock. If 
kernelspace allocates superblock entries from the beginning and userspace 
allocates them from the end, they won't cross each other.

Mikulas
