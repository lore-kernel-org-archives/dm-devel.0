From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: dm-thin btree and incremental backup issue
Date: Tue, 2 Jul 2013 10:41:31 +0800
Message-ID: <CAKTMprP=7G-b83cHeo4OfYSKVktm5HAdofQhJY0=LKH2=dgWpQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi folks,

I am currently implementing an incremental backup tool of
dm-thin-provisioning volumes based on this post
(https://www.redhat.com/archives/dm-devel/2012-May/msg00140.html).
I clone the latest thin-provisioning-tools from github and use ubuntu
13.04 (linux 3.8.0-19) as host OS. However, as I try to perform some
stress tests on my backup tool, I find a weird output of thin_dump
which I cannot be sure if it is a bug or not.

This output can be reproduced by the following steps:
1. create an origin logical volume lv1 with lvm2
2. write some data into lv1
3. take a snapshot on lv1
4. create another origin logical volume lv2
5. write some data into lv2

As you can see from the output of thin_dump listed below, the data
mappings of lv2 (dev_id="3") is duplicated in both lv1 (dev_id="1")
and its snapshot (dev_id="2").
Is this normal?

Any help would be grateful
Thanks

Dennis

The output of thin_dump is summarized as follow:

<superblock uuid="" time="1" transaction="3" data_block_size="2048"
nr_data_blocks="9216 metadata_snap="3">
  <device dev_id="1" mapped_blocks="1753" transaction="0"
creation_time="0" snap_time="1">
    <single_mapping origin_block="0" data_block="1753" time="1"/>
    <range_mapping origin_begin="1" data_begin="72" length="31" time="0"/>
    <single_mapping origin_block="32" data_block="1" time="0"/>
    <range_mapping origin_begin="33" data_begin="103" length="2" time="0"/>
    <single_mapping origin_block="35" data_block="968" time="0"/>
    <range_mapping origin_begin="36" data_begin="1049" length="2" time="0"/>
    <single_mapping origin_block="38" data_block="1207" time="0"/>
    <range_mapping origin_begin="39" data_begin="1281" length="3" time="0"/>
    <range_mapping origin_begin="42" data_begin="1465" length="2" time="0"/>
    <single_mapping origin_block="128" data_block="2" time="0"/>
    <range_mapping origin_begin="129" data_begin="105" length="63" time="0"/>
    <range_mapping origin_begin="192" data_begin="867" length="21" time="0"/>
    <range_mapping origin_begin="213" data_begin="922" length="11" time="0"/>
    <range_mapping origin_begin="224" data_begin="168" length="12" time="0"/>
    <range_mapping origin_begin="236" data_begin="863" length="4" time="0"/>
    <range_mapping origin_begin="240" data_begin="180" length="144" time="0"/>
    <single_mapping origin_block="384" data_block="3" time="0"/>
    <range_mapping origin_begin="385" data_begin="933" length="7" time="0"/>
    <range_mapping origin_begin="392" data_begin="324" length="248" time="0"/>
    <single_mapping origin_block="640" data_block="4" time="0"/>
    <range_mapping origin_begin="641" data_begin="940" length="7" time="0"/>
    <range_mapping origin_begin="648" data_begin="572" length="243" time="0"/>
    <range_mapping origin_begin="891" data_begin="947" length="5" time="0"/>
    <single_mapping origin_block="896" data_block="5" time="0"/>
    <range_mapping origin_begin="897" data_begin="920" length="2" time="0"/>
    <range_mapping origin_begin="899" data_begin="952" length="5" time="0"/>
    <range_mapping origin_begin="904" data_begin="815" length="48" time="0"/>
    <range_mapping origin_begin="952" data_begin="888" length="32" time="0"/>
                                        continue ...
    <single_mapping origin_block="0" data_block="1754" time="1"/>
    <single_mapping origin_block="32" data_block="1755" time="1"/>
    <single_mapping origin_block="128" data_block="1756" time="1"/>
    <single_mapping origin_block="384" data_block="1757" time="1"/>
    <single_mapping origin_block="640" data_block="1758" time="1"/>
    <single_mapping origin_block="896" data_block="1759" time="1"/>
    <range_mapping origin_begin="1024" data_begin="1760" length="64" time="1"/>
    <single_mapping origin_block="1152" data_block="1824" time="1"/>
    <single_mapping origin_block="2047" data_block="1825" time="1"/>
  </device>
  <device dev_id="2" mapped_blocks="1753" transaction="1"
creation_time="1" snap_time="1">
    <single_mapping origin_block="0" data_block="0" time="0"/>
    <range_mapping origin_begin="1" data_begin="72" length="31" time="0"/>
    <single_mapping origin_block="32" data_block="1" time="0"/>
    <range_mapping origin_begin="33" data_begin="103" length="2" time="0"/>
    <single_mapping origin_block="35" data_block="968" time="0"/>
    <range_mapping origin_begin="36" data_begin="1049" length="2" time="0"/>
    <single_mapping origin_block="38" data_block="1207" time="0"/>
    <range_mapping origin_begin="39" data_begin="1281" length="3" time="0"/>
    <range_mapping origin_begin="42" data_begin="1465" length="2" time="0"/>
    <single_mapping origin_block="128" data_block="2" time="0"/>
    <range_mapping origin_begin="129" data_begin="105" length="63" time="0"/>
    <range_mapping origin_begin="192" data_begin="867" length="21" time="0"/>
    <range_mapping origin_begin="213" data_begin="922" length="11" time="0"/>
                                         continue ...
    <single_mapping origin_block="0" data_block="1754" time="1"/>
    <single_mapping origin_block="32" data_block="1755" time="1"/>
    <single_mapping origin_block="128" data_block="1756" time="1"/>
    <single_mapping origin_block="384" data_block="1757" time="1"/>
    <single_mapping origin_block="640" data_block="1758" time="1"/>
    <single_mapping origin_block="896" data_block="1759" time="1"/>
    <range_mapping origin_begin="1024" data_begin="1760" length="64" time="1"/>
    <single_mapping origin_block="1152" data_block="1824" time="1"/>
    <single_mapping origin_block="2047" data_block="1825" time="1"/>
  </device>
  <device dev_id="3" mapped_blocks="72" transaction="2"
creation_time="1" snap_time="1">
    <single_mapping origin_block="0" data_block="1754" time="1"/>
    <single_mapping origin_block="32" data_block="1755" time="1"/>
    <single_mapping origin_block="128" data_block="1756" time="1"/>
    <single_mapping origin_block="384" data_block="1757" time="1"/>
    <single_mapping origin_block="640" data_block="1758" time="1"/>
    <single_mapping origin_block="896" data_block="1759" time="1"/>
    <range_mapping origin_begin="1024" data_begin="1760" length="64" time="1"/>
    <single_mapping origin_block="1152" data_block="1824" time="1"/>
    <single_mapping origin_block="2047" data_block="1825" time="1"/>
  </device>
</superblock>
