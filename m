From: Jim Minter <jminter@redhat.com>
Subject: potential dm-thin recovery issue
Date: Wed, 6 Mar 2013 08:26:55 -0500 (EST)
Message-ID: <15744185.65.1362576412628.JavaMail.javamailuser@localhost>
References: <1196562.58.1362575588488.JavaMail.javamailuser@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1196562.58.1362575588488.JavaMail.javamailuser@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

Following on from my previous e-mail ("dm-thin discard issue"), I'm having trouble recovering from the metadata corruption state I got into.  I'm using the latest userland tools cloned from https://github.com/jthornber/thin-provisioning-tools .  Here's what I've tried; am I going wrong somewhere, or is there potentially an issue with the tools?

# thin_dump /dev/mapper/vg-meta >/tmp/meta
# cat /tmp/meta
<superblock uuid="" time="1" transaction="0" data_block_size="128" nr_data_blocks="16384">
  <device dev_id="0" mapped_blocks="0" transaction="0" creation_time="0" snap_time="1">
  </device>
  <device dev_id="1" mapped_blocks="8192" transaction="0" creation_time="1" snap_time="1">
    <range_mapping origin_begin="0" data_begin="0" length="8192" time="0"/>
  </device>
</superblock>
# dmsetup table
vg-pool: 0 2097152 linear 252:16 264192
fedora-swap: 0 8257536 linear 252:2 2048
fedora-root: 0 32653312 linear 252:2 8259584
vg-meta: 0 262144 linear 252:16 2048
# thin_restore -i /tmp/meta -o /dev/mapper/vg-meta
recursive 'new_block()' not supported
#

# thin_dump -r /dev/mapper/vg-meta >/tmp/meta2
# diff /tmp/meta /tmp/meta2
#

(so the -r option doesn't help me here)

# dd if=/dev/zero of=/dev/mapper/vg-meta bs=1M &>/dev/null
# thin_restore -i /tmp/meta -o /dev/mapper/vg-meta
recursive 'new_block()' not supported
#

(so wiping the metadata volume before restoring doesn't help either)

Cheers,

Jim
