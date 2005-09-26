From: Richard J Moore <richardj_moore@uk.ibm.com>
Subject: Clariion configuration with multi-path tools
Date: Mon, 26 Sep 2005 13:12:43 +0100
Message-ID: <OFA910A798.9465F8A6-ON80257088.0042AF06-80257088.00431555@uk.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids





Hello,

I am trying to configure a Clariion CX to work under multipath-tools.


  a. multipath -v2 -d



returns a

nld0016:~ # multipath -v2 -d
Path not correctly configured for failoverPath not correctly configured for
failoverPath not correctly configured for failoverPath not correctly
configured for failoverPath not correctly configured for failoverPath not
correctly configured for failoverPath not correctly configured for
failoverPath not correctly configured for failoverPath not correctly
configured for failoverPath not correctly configured for failoverPath not
correctly configured for failoverPath not correctly configured for
failoverPath not correctly configured for failoverPath not correctly
configured for failoverPath not correctly configured for failoverPath not
correctly configured for failoverPath not correctly configured for
failoverPath not correctly configured for failoverPath not correctly
configured for failoverPath not correctly configured for failoverPath not

I am told that I need to explicily specify for all paths.

arraycommpath 1,
failover type 1, system type 3.

How is this specified? What's the format of the config file?


Thanks,


- -
Richard J Moore
IBM Advanced Linux Response Team - Linux Technology Centre
MOBEX: 264807; Mobile (+44) (0)7739-875237
Office: (+44) (0)1962-817072
