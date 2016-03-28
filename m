From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: [PATCH] thin_dump: added --device-id, --skip-mappings,
 and new output --format's
Date: Mon, 28 Mar 2016 22:05:22 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603282124000.13440@mail.ewheeler.net>
References: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
	<20160324153509.GA3101@rh-vpn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160324153509.GA3101@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 24 Mar 2016, Joe Thornber wrote:

> On Tue, Mar 15, 2016 at 01:45:15AM +0000, Eric Wheeler wrote:
> > Hi Joe,
> > 
> > Please review the patch below when you have a moment.  I am interested in 
> > your feedback, and also interested in having this functionality merged 
> > upstream.  This was written against thin-provisioning-tools.git tag 
> > v0.5.6.
> 
> These changes are now on the v0.7-devel branch:
> 
> i) --dev-id to filter thin_dump output on device id, multiple selections allowed.
> ii) --skip-mappings
> iii) thin_dump now takes a format called 'custom' that let's you use a plugin emitter of your own.
> 
>      eg, 
> 
>      thin_dump --format custom=contrib/ewheeler_emitter.so /dev/sda
> 
> 
> The contrib/ directory is for third party contributions.  Use 'make
> contrib' to build it.  I've put your emitter and tmakatos' emitter in
> there already.


It took me a bit to figure out that I needed --enable-testing to get 
contrib/ to build.  You might remove the --enable-testing requirement 
within the Makefile if contrib will remain as an optional Makefile target 
that doesn't usually build with `make`.

Also FYI: I noticed that `-ldl' needed added to to the g++ linking 
line:

/usr/src/thin-provisioning-tools/thin-provisioning/shared_library_emitter.cc:15: undefined reference to `dlopen' 
/usr/src/thin-provisioning-tools/thin-provisioning/shared_library_emitter.cc:19: undefined reference to `dlerror' 
/usr/src/thin-provisioning-tools/thin-provisioning/shared_library_emitter.cc:20: undefined reference to `dlsym' 
/usr/src/thin-provisioning-tools/thin-provisioning/shared_library_emitter.cc:22: undefined reference to `dlerror' 
/usr/src/thin-provisioning-tools/thin-provisioning/shared_library_emitter.cc:17: undefined reference to `dlerror'

So I added the -ldl as below:

g++ -g -Wall -fPIC -fno-strict-aliasing -std=c++11 -O8  
-DSTRERROR_R_CHAR_P   -o bin/pdata_tools base/application.o base/base64.o 
base/disk_units.o base/endian_utils.o base/error_state.o 
base/error_string.o base/grid_layout.o base/progress_monitor.o 
base/rolling_hash.o base/xml_utils.o block-cache/block_cache.o 
caching/cache_check.o caching/cache_dump.o caching/cache_metadata_size.o 
caching/cache_repair.o caching/cache_restore.o caching/commands.o 
caching/hint_array.o caching/mapping_array.o caching/metadata.o 
caching/metadata_dump.o caching/restore_emitter.o caching/superblock.o 
caching/xml_format.o era/commands.o era/era_array.o era/era_check.o 
era/era_detail.o era/era_dump.o era/era_invalidate.o era/era_restore.o 
era/metadata.o era/metadata_dump.o era/restore_emitter.o era/superblock.o 
era/writeset_tree.o era/xml_format.o main.o persistent-data/checksum.o 
persistent-data/data-structures/bitset.o 
persistent-data/data-structures/bloom_filter.o 
persistent-data/data-structures/btree.o persistent-data/error_set.o 
persistent-data/file_utils.o persistent-data/hex_dump.o 
persistent-data/space-maps/careful_alloc.o 
persistent-data/space-maps/disk.o persistent-data/space-maps/recursive.o 
persistent-data/space_map.o persistent-data/transaction_manager.o 
persistent-data/validators.o thin-provisioning/commands.o 
thin-provisioning/cache_stream.o thin-provisioning/chunk_stream.o 
thin-provisioning/device_tree.o thin-provisioning/fixed_chunk_stream.o 
thin-provisioning/human_readable_format.o thin-provisioning/mapping_tree.o 
thin-provisioning/metadata.o thin-provisioning/metadata_checker.o 
thin-provisioning/metadata_counter.o thin-provisioning/metadata_dumper.o 
thin-provisioning/pool_stream.o thin-provisioning/restore_emitter.o 
thin-provisioning/rmap_visitor.o thin-provisioning/superblock.o 
thin-provisioning/shared_library_emitter.o thin-provisioning/thin_check.o 
thin-provisioning/thin_delta.o thin-provisioning/thin_dump.o 
thin-provisioning/thin_ls.o thin-provisioning/thin_metadata_size.o 
thin-provisioning/thin_pool.o thin-provisioning/thin_repair.o 
thin-provisioning/thin_restore.o thin-provisioning/thin_rmap.o 
thin-provisioning/thin_trim.o thin-provisioning/xml_format.o -laio -lexpat 
-lstdc++ -ldl
         ^^^^  ADDED


> 
> I hope that covers everything you need.
> 
> - Joe
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
