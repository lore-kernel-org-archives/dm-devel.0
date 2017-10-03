From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-crypt: Reject sector_size feature
	if	device length is not aligned to it
Date: Tue, 3 Oct 2017 13:05:08 +0100
Message-ID: <20171003120508.GA9979@agk-dp.fab.redhat.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
	<b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
	<alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Mon, Oct 02, 2017 at 10:43:56AM -0400, Mikulas Patocka wrote:
> Here I send a patch that checks invalid limits when the table is loaded 
> and aborts the table load ioctl with an error.
 
The code does not already do this because it needs to avoid unnecessary
failures if any characteristics of the devices underneath change after
the 'load' but before the 'resume' (as can happen, for example, when a
tree of devices gets updated by performing all the loads before all the
resumes).

Alasdair
