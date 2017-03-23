From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: multipath-tools (patch): Do not select sysfs
 prioritizer for RDAC arrays (was Re: [PATCH 00/33] multipath-tools fixes
 from SUSE)
Date: Thu, 23 Mar 2017 20:40:21 +0000
Message-ID: <AD0E2CA8-FC3B-4541-BCD2-C8D424773E68@netapp.com>
References: <20170228162329.14517-1-mwilck@suse.com>
	<baaf80fb-ff18-c8b1-c1e5-ef1bf64334c4@gmail.com>
	<1488355933.23148.4.camel@suse.com>
	<9300564f-d989-b6d9-f170-2e4385fa1c1e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9300564f-d989-b6d9-f170-2e4385fa1c1e@gmail.com>
Content-Language: en-US
Content-ID: <3EA88C6E9BC956439B512C4FC7056C76@namprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "Schremmer, Steven" <Steve.Schremmer@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On 3/23/17, 1:43 PM, "dm-devel-bounces@redhat.com on behalf of Xose Vazquez Perez" <dm-devel-bounces@redhat.com on behalf of xose.vazquez@gmail.com> wrote:

    On 03/01/2017 09:12 AM, Martin Wilck wrote:
    
    > On Tue, 2017-02-28 at 23:44 +0100, Xose Vazquez Perez wrote:
    >>
    >> There is a recent one missing:
    >> ---
    >> Subject: libmultipath/propsel: Do not select sysfs prioritizer for
    >> RDAC arrays
    > 
    > Well observed :-) This one still needs verification. We will submit it
    > when it's final.
    
    Is it stable/tested enough to be merged?

This patch has been tested and verified with SUSE 12 as part of our process with the Bugzilla, so based on that I would say yes.

Thanks,   

--
Sean Stewart
Linux Software Engineer
Hyperscale Storage Group

NetApp
