From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 28 Feb 2011 13:29:20 +0000
Message-ID: <20110228132920.GC3626@agk-dp.fab.redhat.com>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>
	<20110228114801.GZ3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
	<20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eli Malul <eli.malul@kaminario.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 28, 2011 at 03:13:42PM +0200, Eli Malul wrote:
> But, do you know why having 10,000 extents is causing this overwhelming
> memory usage?
 
Nobody considered having a huge number of tiny mirrors reasonable or necessary
so no attempt has been made to optimise that situation.

Alasdair
