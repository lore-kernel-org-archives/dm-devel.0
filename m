From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Question on DM reload ioctl failure
Date: Wed, 18 Feb 2009 13:24:07 -0800
Message-ID: <1234992247.15552.49.camel@chandra-ubuntu>
References: <D00AA2C108EC0346B503219C7565A66F038D99@ausx3mpc138.aus.amer.dell.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D00AA2C108EC0346B503219C7565A66F038D99@ausx3mpc138.aus.amer.dell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Yanqing,

I tested RC4 and did not come across this. Can you tell me what you were
trying, I will try to reproduce.

regards,

chandra
On Wed, 2009-02-18 at 11:39 -0600, Yanqing_Liu@Dell.com wrote:
> In testing with rdac device handler on SLES11 RC4, there is an issue of
> reload ioctl failure when trying to reload device map for rdac device.
> Because of this, no multipathing device is created. The multipath tool
> package version is the built-in version (0.4.8-37.1).
> 
> The error message is as follows:
> 
> Feb 18 09:52:33 | mpathc: verified path sdf dev_t 8:80
> Feb 18 09:52:33 | mpathc: pgfailback = -2 (controller setting)
> Feb 18 09:52:33 | mpathc: pgpolicy = group_by_prio (controller setting)
> Feb 18 09:52:33 | mpathc: selector = round-robin 0 (internal default)
> Feb 18 09:52:33 | mpathc: features = 0 (internal default)
> Feb 18 09:52:33 | mpathc: hwhandler = 1 rdac (controller setting)
> Feb 18 09:52:33 | mpathc: rr_weight = 1 (internal default)
> Feb 18 09:52:33 | mpathc: minio = 1000 (config file default)
> Feb 18 09:52:33 | mpathc: no_path_retry = NONE (internal default)
> Feb 18 09:52:33 | mpathc: pg_timeout = NONE (internal default)
> Feb 18 09:52:33 | mpathc: assembled map [0 1 rdac 1 1 round-robin 0 2 1
> 8:32 1000 8:80 1000]
> 
> Feb 18 09:52:33 | mpathc: set ACT_CREATE (map does not exist)
> Feb 18 09:52:33 | libdevmapper: ioctl/libdm-iface.c(1674): dm info
> mpathc  NF   [16384]
> Feb 18 09:52:33 | mpathc: addmap [0 20971520 multipath 0 1 rdac 1 1
> round-robin 0 2 1 8:32 1000 8:80 1000]
> 
> Feb 18 09:52:33 | libdevmapper: ioctl/libdm-iface.c(1674): dm create
> mpathc mpath-360019b9000d456c0000029b74979b0da OF   [16384]
> Feb 18 09:52:33 | libdevmapper: libdm-common.c(599): mpathc: Stacking
> NODE_ADD (253,0) 0:6 0640
> Feb 18 09:52:33 | libdevmapper: ioctl/libdm-iface.c(1674): dm reload
> mpathc  OF   [16384]
> Feb 18 09:52:33 | libdevmapper: ioctl/libdm-iface.c(1691):
> device-mapper: reload ioctl failed: Invalid argument
> Feb 18 09:52:33 | libdevmapper: ioctl/libdm-iface.c(1674): dm remove
> mpathc  NF   [16384]
> 
> Any suggestion?
> 
> Thanks,
> Yanqing
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
