From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH v4 0/2] dm unstriped: add new target
Date: Mon, 18 Dec 2017 19:08:50 +0100
Message-ID: <cover.1513618685.git.heinzm@redhat.com>
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
To: heinzm@redhat.com, dm-devel@redhat.com
Cc: scott.bauer@intel.com
List-Id: dm-devel.ids

This is a quick rework of the new "unstripe" target
(undoes a striped/raid0 mapping) v3 patch series
authored by Scott Bauer addressing some points
discussed here and more.

Addressed:
- rename target to "unstriped"
- enhance constructor header
- add more consistency checks to constructor imposing
  divisibility of device and drive length by chunk size;
  device length has to be divisible by total number of drives
- use destructor in constructor error pathes
- move a few local variables to 'struct unstripe'
- add missing unstripe_status() function using
  new variables in ^ struct to address requirement
  for dm targets
- tweaked config variable name Kconfig text

Not addressed:
- documentation (kept as is in this series for completeness) 

Example of 'dmsetup table' output:
# dmsetup table nvm-s s1 s2
nvm-s: 0 262144 raid raid0 1 8 2 - 254:2 - 254:3
s1: 0 131072 unstriped 254:4 0 2 8
s2: 0 131072 unstriped 254:4 1 2 8


Scott,
please check, test and tell, if the additonal constraints
on length divisibility are too restrictive and how to go
about the 2 FIXMEs.


Tested-by: Heinz Mauelshagen <heinzm@redhat.com>

Heinz Mauelshagen (2):
  dm unstriped: new "unstriped" raid0/striped device
  dm unstriped: add documentation for unstriped target

 Documentation/device-mapper/dm-unstripe.txt | 130 ++++++++++++++++
 drivers/md/Kconfig                          |  11 ++
 drivers/md/Makefile                         |   1 +
 drivers/md/dm-unstripe.c                    | 233 ++++++++++++++++++++++++++++
 4 files changed, 375 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-unstripe.txt
 create mode 100644 drivers/md/dm-unstripe.c

-- 
2.14.3
