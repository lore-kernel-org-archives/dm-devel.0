From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH 0/9] dm-crypt patches
Date: Wed, 09 Apr 2014 10:46:51 +0200
Message-ID: <534508FB.3030609@redhat.com>
References: <alpine.LRH.2.02.1404051359500.8509@file01.intranet.prod.int.rdu2.redhat.com>	<534414DD.1040500@redhat.com>
	<20140408154416.GB4723@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140408154416.GB4723@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 04/08/2014 05:44 PM, Mike Snitzer wrote:
> How is it that you've extracted these results from the test run?  I'd be
> open to rerunning the same on my testbed (1 Intel Xeon E5649 Westmere-EP
> with 12 logical cores, AES, and 6 SAS devices for RAID, 1 STEC PCIe SSD)
>
> I could also yield this testbed to you if that'd be easier than you
> telling me how to extract the test results.

Thanks Mike!

Pasting new results for loaned machine and things are getting more 
interesting (with respect to Marian's reply):

single (rotational) device:

TEST NAME                 OPERATION AGGRB_A KB/s AGGRB_B KB/s DIFF A->B
------------------------- --------- ------------ ------------ ---------
disk_nocrypt-read         READ      479129       478528        -0.13 %
disk_nocrypt-write        WRITE     225040       225718         0.30 %
disk_nocrypt-randread     READ       30150        30193         0.14 %
disk_nocrypt-randwrite    WRITE      39059        39546         1.25 %
disk_nocrypt-rw           READ       92477        94021         1.67 %
disk_nocrypt-rw           WRITE      93242        94800         1.67 %
disk_nocrypt-randrw       READ       14426        14902         3.30 %
disk_nocrypt-randrw       WRITE      14388        14862         3.29 %
zero-read                 READ      272889       354069        29.75 %
zero-write                WRITE     145721       306175       110.11 %
zero-randread             READ      482888       599366        24.12 %
zero-randwrite            WRITE     151175       346728       129.36 %
zero-rw                   READ       91280       131950        44.56 %
zero-rw                   WRITE      92036       133042        44.55 %
zero-randrw               READ       72625       142476        96.18 %
zero-randrw               WRITE      72433       142099        96.18 %
disk-read                 READ      193161       210156         8.80 %
disk-write                WRITE      33845       182790       440.08 %
disk-randread             READ       29746        29640        -0.36 %
disk-randwrite            WRITE       7783        31689       307.16 %
disk-rw                   READ       23954        69686       190.92 %
disk-rw                   WRITE      24152        70263       190.92 %
disk-randrw               READ        6770        12523        84.98 %
disk-randrw               WRITE       6753        12490        84.95 %

single PCIe SSD device:

(Staring to immense difference between sequential reads and random 
reads. Can it be there some sort of raid inside SSD card?)

TEST NAME                 OPERATION AGGRB_A KB/s AGGRB_B KB/s DIFF A->B
------------------------- --------- ------------ ------------ ---------
disk_nocrypt-read         READ      1072537      1145446        6.80 %
disk_nocrypt-write        WRITE      843924       828586       -1.82 %
disk_nocrypt-randread     READ      2091110      2108825        0.85 %
disk_nocrypt-randwrite    WRITE     1149542      1137971       -1.01 %
disk_nocrypt-rw           READ       425704       426661        0.22 %
disk_nocrypt-rw           WRITE      429228       430193        0.22 %
disk_nocrypt-randrw       READ       534206       532311       -0.35 %
disk_nocrypt-randrw       WRITE      532791       530900       -0.35 %
zero-read                 READ       271388       351871       29.66 %
zero-write                WRITE      143748       300000      108.70 %
zero-randread             READ       487264       600310       23.20 %
zero-randwrite            WRITE      148958       344308      131.14 %
zero-rw                   READ        90927       131659       44.80 %
zero-rw                   WRITE       91679       132748       44.80 %
zero-randrw               READ        71325       137468       92.73 %
zero-randrw               WRITE       71136       137104       92.74 %
disk-read                 READ       243854       269678       10.59 %
disk-write                WRITE      179773       300408       67.10 %
disk-randread             READ       518848       647679       24.83 %
disk-randwrite            WRITE      195314       348398       78.38 %
disk-rw                   READ       103381       131270       26.98 %
disk-rw                   WRITE      104237       132356       26.98 %
disk-randrw               READ        93681       145719       55.55 %
disk-randrw               WRITE       93433       145333       55.55 %

4 rotational devices forming md raid5, 64KiB chunk size:

TEST NAME                 OPERATION AGGRB_A KB/s AGGRB_B KB/s DIFF A->B
------------------------- --------- ------------ ------------ ---------
disk_nocrypt-read         READ      560436       547773        -2.26 %
disk_nocrypt-write        WRITE     360552       359039        -0.42 %
disk_nocrypt-randread     READ       62256        62118        -0.22 %
disk_nocrypt-randwrite    WRITE      51591        52289         1.35 %
disk_nocrypt-rw           READ       59680        58955        -1.21 %
disk_nocrypt-rw           WRITE      60174        59443        -1.21 %
disk_nocrypt-randrw       READ       18328        18219        -0.59 %
disk_nocrypt-randrw       WRITE      18280        18171        -0.60 %
zero-read                 READ      274712       353651        28.74 %
zero-write                WRITE     146469       300904       105.44 %
zero-randread             READ      498736       603246        20.95 %
zero-randwrite            WRITE     150131       355003       136.46 %
zero-rw                   READ       92481       132359        43.12 %
zero-rw                   WRITE      93246       133455        43.12 %
zero-randrw               READ       72278       141164        95.31 %
zero-randrw               WRITE      72086       140790        95.31 %
disk-read                 READ      177154       203054        14.62 %
disk-write                WRITE      71057       241913       240.45 %
disk-randread             READ       58757        58988         0.39 %
disk-randwrite            WRITE      14453        28966       100.42 %
disk-rw                   READ       59772        67560        13.03 %
disk-rw                   WRITE      60267        68120        13.03 %
disk-randrw               READ        9634        12815        33.02 %
disk-randrw               WRITE       9608        12781        33.02 %

4 rotational devices forming md raid5, 512KiB chunk size:

(I'll repeat this one since there's strange increase in random read 
performance on raw raid5 device, see line "disk_nocrypt-randread"):

TEST NAME                 OPERATION AGGRB_A KB/s AGGRB_B KB/s DIFF A->B
------------------------- --------- ------------ ------------ ---------
disk_nocrypt-read         READ      734811       730206        -0.63 %
disk_nocrypt-write        WRITE     264474       259773        -1.78 %
disk_nocrypt-randread     READ       64387        83218        29.25 %
disk_nocrypt-randwrite    WRITE      52671        51898        -1.47 %
disk_nocrypt-rw           READ       75785        73469        -3.06 %
disk_nocrypt-rw           WRITE      76413        74077        -3.06 %
disk_nocrypt-randrw       READ       17664        17690         0.15 %
disk_nocrypt-randrw       WRITE      17617        17643         0.15 %
zero-read                 READ      270967       354099        30.68 %
zero-write                WRITE     145277       307230       111.48 %
zero-randread             READ      478481       585805        22.43 %
zero-randwrite            WRITE     149734       349997       133.75 %
zero-rw                   READ       91742       127760        39.26 %
zero-rw                   WRITE      92501       128818        39.26 %
zero-randrw               READ       78925       145437        84.27 %
zero-randrw               WRITE      78716       145051        84.27 %
disk-read                 READ      203705       237220        16.45 %
disk-write                WRITE      64068       230051       259.07 %
disk-randread             READ       60698        77793        28.16 %
disk-randwrite            WRITE      18535        32227        73.87 %
disk-rw                   READ       49023        65775        34.17 %
disk-rw                   WRITE      49429        66320        34.17 %
disk-randrw               READ       10740        13084        21.82 %
disk-randrw               WRITE      10712        13049        21.82 %

Now I would like to work on simulating different workloads (these tests 
were simulating 4 jobs in fio on otherwise idling machine)

Ondrej
