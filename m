From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: killall DEFAULT_*
Date: Thu, 23 Jun 2016 19:31:48 +0200
Message-ID: <ce51a338-902c-039e-8d22-daca3edadcc1@gmail.com>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
	<1466689340-5590-4-git-send-email-xose.vazquez@gmail.com>
	<576BE8CE.9040201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <576BE8CE.9040201@suse.de>
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
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

On 06/23/2016 03:49 PM, Hannes Reinecke wrote:

> Why do you need to set it to 'DEFAULT_CHECKER'?
> It's the default, right?
> So it should be sufficient to just delete those lines...

More candidates to be deleted ???

      1                 .minio         = DEFAULT_MINIO,
      1                 .minio_rq      = DEFAULT_MINIO_RQ,
     28                 .prio_name     = DEFAULT_PRIO,
     44                 .hwhandler     = DEFAULT_HWHANDLER,
     48                 .features      = DEFAULT_FEATURES,
