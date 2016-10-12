From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: preload also scsi_dh_hp_sw
 before run multipathd
Date: Wed, 12 Oct 2016 14:54:09 +0200
Message-ID: <256cb0be-211e-8674-d727-3aa4576822fe@gmail.com>
References: <20161011125515.8523-1-xose.vazquez@gmail.com>
	<2779bae3-28f4-9b0f-b014-583b717f715e@suse.de>
	<a00c50a5-3eae-edfb-f793-89fee7cd734c@gmail.com>
	<3b74a980-ebe9-cda3-4d98-0072ae2c7f89@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3b74a980-ebe9-cda3-4d98-0072ae2c7f89@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/12/2016 02:43 PM, Hannes Reinecke wrote:
> On 10/12/2016 01:37 PM, Xose Vazquez Perez wrote:

>> scsi_dh_hp_sw is used also for dec/compaq ESA12000 and RA8000 arrays with HSG80 controller.
>> And in HP MSA 1000/1500 and EVA 3000/5000, with old firmware.
>>
> EVA? I sincerely doubt that.
> Do you really have an example for that?

        {
                /* MSA 1000/1500 and EVA 3000/5000, with old firmware */
                .vendor        = "(COMPAQ|HP)",
                .product       = "(MSA|HSV)1[01]0",
                .hwhandler     = "1 hp_sw",
                .pgpolicy      = GROUP_BY_PRIO,
                .no_path_retry = 12,
                .checker_name  = HP_SW,
                .prio_name     = PRIO_HP_SW,
        },

HSV100 is HP StorageWorks Enterprise Virtual Array 3000:
 http://h18000.www1.hp.com/products/quickspecs/archives_Division/11619_div_v9/11619_div.PDF
HSV110 is HP StorageWorks Enterprise Virtual Array 5000:
 https://www.hpe.com/h20195/v2/GetPDF.aspx/c04282828.pdf
