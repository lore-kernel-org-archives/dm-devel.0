From: Erez Zilber <erezz@voltaire.com>
Subject: Throughput when using multibus
Date: Tue, 19 Feb 2008 14:46:43 +0200
Message-ID: <47BACFB3.5040300@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I'd like to use my storage in active/active mode. I connected a machine
with 2 FC cables to a switch and connected the FC storage with 2 cables
to the same switch. I expected to get higher throughput from the device
in active/active mode, but I get the same performance like I had without
multipath.

Here's the conf file that I use:

defaults {
        polling_interval 5
        failback immediate
        no_path_retry 3
        user_friendly_names yes
        path_grouping_policy    multibus
}

I see the device 4 times (which is ok):

path7 (3600c0ff000d508d7dff2894701000000) DotHill,R/Evo 2730-2R
[size=82G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=4][active]
 \_ 8:0:3:8 sdah 66:16  [active][ready]
 \_ 9:0:1:8 sdar 66:176 [active][ready]
 \_ 9:0:3:8 sdbb 67:80  [active][ready]
 \_ 8:0:1:8 sdx  65:112 [active][ready]

BTW - I see the both FC ports of the FC storage are used, but with low
utilization.

Erez
