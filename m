From: Alasdair G Kergon <agk@redhat.com>
Subject: storage-logger: Recording changes to the udev database
Date: Thu, 26 Mar 2020 23:31:45 +0000
Message-ID: <20200326233144.GM17504@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

I'm experimenting with ways of recording changes to the udev database so
you can look back at the history of the storage stack on a particular
machine.  This is still a work-in-progress, but it's reached a point
where I'd like more people to try it out.

I've written a shell script that records data related to storage uevents
in the system journal and a perl script that helps you to interrogate
this data later to create a representation of the storage components.

If you're interested, please try this out and let me know if you think
pursing this approach further would lead to something that you would
use and distributions should ship.

Source code:
  https://github.com/lvmteam/storage-logger
Fedora builds:
  https://copr.fedorainfracloud.org/coprs/agk/storage-logger/build/1320735/
Presentation:
  https://fosdem.org/2020/schedule/event/storage_logger/


Storage-logger
==============
The storage-logger project maintains a record of the storage
configuration of a linux system as it changes over time.
The idea is to provide a quick way to check the state
of a system at times in the past.

Logging
=======
The initial logging implementation is triggered by storage uevents and
consists of two components:

1. A new udev rule file, 99-zzz-storage-logger.rules, which runs after
all the other rules have run and invokes:

2. A script, udev_storage_logger.sh, that captures relevant
information about devices that changed and stores it in the system
journal.

The effect is to log relevant uevents plus some supplementary
information.  It does not yet handle filesystem-related events.

Reporting
=========
Two methods to query the data are offered:

1. journalctl
Reports the raw data using simple filtering.
Data is tagged with the identifier UDEVLOG and retrievable as
key-value pairs.
All the captured data:
  journalctl -t UDEVLOG --output verbose
or as JSON:
  journalctl -t UDEVLOG --output json
Between a time range:
  --since 'YYYY-MM-DD HH:MM:SS' 
  --until 'YYYY-MM-DD HH:MM:SS'
Other filtering features are described in the man page.

2. lsblkj
This wrapper creates a dummy system environment that "looks like" the
system did at a specified earlier time and then runs lsblk against it.
It accepts --since and --until arguments to pass to journalctl to
select the desired data, and passes other arguments controlling
the output format to the real lsblk.  
Use --verbose to watch it setting up the temporary environment .
Use --dry-run to see what it would do without actually doing it.
Use --git to create a git repository recording the changes over time.
 
Alasdair
-- 
agk@redhat.com
