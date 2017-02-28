From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 00/33] multipath-tools fixes from SUSE
Date: Tue, 28 Feb 2017 23:44:34 +0100
Message-ID: <baaf80fb-ff18-c8b1-c1e5-ef1bf64334c4@gmail.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/28/2017 05:22 PM, Martin Wilck wrote:

> As announced previously, here comes a collection of multipath-tools patches
> that SUSE is using for SLES12 SP2.
> 
> The whole series can be roughly broken down into the following logical
> parts. Details can be found in the indvidual patches.

There is a recent one missing:
---
Subject: libmultipath/propsel: Do not select sysfs prioritizer for RDAC arrays

Recent RDAC (NetApp E-Series) firmware implemented an internal load
balancer and switched to implicit ALUA.
Unfortunately the load balancer relies on periodic REPORT TARGET PORT
GROUPS from the host, so we cannot use the sysfs prioritizer here.
---


Martin, thank you for your work.
