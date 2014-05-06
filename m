From: Joe Thornber <thornber@redhat.com>
Subject: Re: are there usage examples for
 dm_sm_metadata_{create|open}?
Date: Tue, 6 May 2014 14:17:18 +0100
Message-ID: <20140506131717.GA11355@debian>
References: <8A51900D08212F40B3DE22453052F6981D0EEE96@wdscexmb02>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <8A51900D08212F40B3DE22453052F6981D0EEE96@wdscexmb02>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

HI John,

On Sat, May 03, 2014 at 02:24:48AM +0000, John Utz wrote:
> So, the stuff in persistent-data sure seems like a good candidate for getting the job done. :-)

It's nice that you're considering using the pd library.  Probably the
simplest user of pd is the dm-era target.

> It seems like the first basic action one would want to perform would
> be to create a metadata 'blob' and then at some point in the future
> one would regularly want to open said metadata blob. The
> dm_sm_metadata_create and open functions seem perfect for the job.
> But for some reason, I am unable to find a place in the md directory
> where this is getting used.

Use dm_tm_create_with_sm(), this creates both the transaction manager,
which you *must* have, and the metadata space map.  See the comment at
the end of drivers/md/persistent-data/dm-transaction-manager.h

> I would have thought that dm-cache-metadata.c would be using it, but
  it doesnt seem to be thinking about this in the same way. It uses
  dm_block_manager_create() and __create_persistent_data_objects().

It does, indirectly.

- Joe
