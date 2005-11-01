From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: multipath + evms problems
Date: Mon, 31 Oct 2005 18:01:44 -0600
Message-ID: <200510311801.44636.kevcorry@us.ibm.com>
References: <200510291248.51290.bernd@bzed.de>
	<200510312320.06690.bernd@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200510312320.06690.bernd@bzed.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, EVMS <evms-devel@lists.sourceforge.net>
List-Id: dm-devel.ids

On Mon October 31 2005 4:20 pm, Bernd Zeimetz wrote:
> Anybody seen these evms erros before?
>
> Oct 29 13:22:54 zeus-2 _2_ Engine: build_target_list: Error getting number
> of devices and groups from the target type. Oct 29 13:22:54 zeus-2 _2_
> Engine: build_target_list: Error building target list. Name =
> 3600601f4a20c000096dc229956b0d711 Oct 29 13:22:54 zeus-2 _2_ LocalDskMgr:
> check_multipath: Error getting DM mapping for disk
> 3600601f4a20c000096dc229956b0d711. [...] x 8 - for every LUN

Please send in the output from "dmsetup ls" and "dmsetup table", and the 
contents of /proc/partitions. Also, run "evms -d debug", and mail me 
(privately) a gzipped copy of /var/log/evms-engine.log.

Thanks,
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
