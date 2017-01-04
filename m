From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: dm stats
Date: Wed, 4 Jan 2017 11:33:46 +0000
Message-ID: <20170104113345.GB6906@dhcp-24-182.fab.redhat.com>
References: <DF4PR84MB01530961D1F61928EF4B4101A0930@DF4PR84MB0153.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <DF4PR84MB01530961D1F61928EF4B4101A0930@DF4PR84MB0153.NAMPRD84.PROD.OUTLOOK.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "A M, Ashalatha" <ashalatha-a.a@hpe.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 21, 2016 at 10:49:06AM +0000, A M, Ashalatha wrote:
> In this documentation, would like to know what is the command to be used to create/print/list stats.
> 
> @stats_create <range> <step> [<program_id> [<aux_data>]]
> 
> @stats_print <region_id> [<starting_line> <number_of_lines>]
> 
> @stats_list [<program_id>]

These are device-mapper messages that you can send to a device to
create, print, or list statistics regions.

All range and step arguments are in sectors and the messages are
issued with the 'dmsetup message' command.

For example:

  # dmsetup message vg_hex/root 0 "@stats_list" 
  0: 35325952+2048 2048 dmstats -
  1: 35325952+2048 2048 dmstats -
  2: 44908544+16384 16384 dmstats DMS_GROUP=vm.img:2#-

This is however a very low-level interface to the dmstats facility;
users are encouraged to use the userspace library (part of libdevmapper
- see libdevmapper.h for API documentation), or the 'dmstats' command
to manage device-mapper statistics.

  # dmstats list
  Name             GrpID RgID ObjType RgStart RgSize  #Areas ArSize  ProgID 
  vg_hex-root          -    0 region   16.84g   1.00m      1   1.00m dmstats
  vg_hex-root          -    1 region   16.84g   1.00m      1   1.00m dmstats
  vm.img               2    2 region   21.41g   8.00m      1   8.00m dmstats
  
This has the benefit of a simpler command interface, automatic rate
conversion for derived metrics (MB/s, queue length, etc.), configurable
time and size units, flexible field control, grouping, aliasing and many
other convenient features - see man 8 dmstats for further details of the
command interface.

> Also, it is documented that 11 stats(Documentation/iostats.txt) would be reported and additional counters as well:
> 
> 12. the total time spent reading in milliseconds
> 
> 13. the total time spent writing in milliseconds
> 
> So are these same as "read_ticks" and "write_ticks" else how different from the ticks?

Yes: these are the fields reported by dmstats as 'read_ticks' and
'write_ticks'. They differ from 'read_time' and 'write_time' in that
they are the time spent _servicing_ (i.e. actively processing) read and
write requests - the two '_time' fields instead track the total
accumulated time for all requests (the time from the request being
submitted to the time when it is completed, summed for all requests).

Regards,
Bryn.
