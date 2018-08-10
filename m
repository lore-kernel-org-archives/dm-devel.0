From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: check the sector size of underlying device when
 verifying start
Date: Fri, 10 Aug 2018 11:56:51 -0400
Message-ID: <20180810155651.GA22384@redhat.com>
References: <alpine.LRH.2.02.1808101122300.16981@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1808101122300.16981@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 10 2018 at 11:23am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> It was found out that these commands would fail:
> # modprobe scsi_debug dev_size_mb=128 sector_size=512
> # dmsetup create crypt0 --table "0 245752 crypt cipher_null-ecb - 0 /dev/sda 16385 1 sector_size:4096"
> with the error
> "device-mapper: table: 253:0: start=16385 not aligned to h/w logical block size 4096 of sda"
> 
> The logic incorrectly checks the starting sector offset on the underlying
> device against the block size of the device that is being created.
> 
> This patch fixes it by checking the starting sector offset against the
> block size of the underlying device, not the device that is being created.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

tweaked like we discussed and staged for 4.19 here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.19&id=b2f9960fd34e6dddba7975133b84263a2f594a20
