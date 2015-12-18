From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 11:39:13 -0600
Message-ID: <n51gc2$oh4$1@ger.gmane.org>
References: <n508c1$8dl$1@ger.gmane.org>
	<22132.12088.729694.12882@quad.stoffel.home>
	<n51dq4$dit$1@ger.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <n51dq4$dit$1@ger.gmane.org>
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

On 12/18/2015 10:55 AM, Ian Pilcher wrote:
> Currently you'll need multiple zodcache devices to create multiple VGs.
> It should be possible to make these devices partitionable with a udev
> rule that calls kpartx as appropriate.

This seems to work:

SUBSYSTEM!="block", GOTO="zodcache_end" 

ACTION=="remove", GOTO="zodcache_end" 

ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="zodcache_end" 

KERNEL=="fd*|sr*", GOTO="zodcache_end" 

 

# Look for a zodcache superblock on the device and start it if found 

RUN+="/usr/sbin/zcstart --udev $tempnode" 

 

# Process partition tables on zodcache devices (but not components) 

ENV{DM_NAME}!="zodcache-*", GOTO="zodcache_end" 

ENV{DM_NAME}=="*-origin", GOTO="zodcache_end" 

ENV{DM_NAME}=="*-cache", GOTO="zodcache_end" 

ENV{DM_NAME}=="*-metadata", GOTO="zodcache_end" 

ENV{ID_PART_TABLE_TYPE}=="dos", RUN+="/usr/sbin/kpartx -a $tempnode" 

 

LABEL="zodcache_end"

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
