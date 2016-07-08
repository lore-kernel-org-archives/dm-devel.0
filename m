From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 0/4] make tur the default path checker
Date: Fri, 8 Jul 2016 14:51:33 +0200
Message-ID: <0f744d4c-a955-081e-0592-5eff58304d56@gmail.com>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
	<CABr-GneaU4xMj2pRTNi3X+qeo4Hm5D-DJCFL7oHq=BDFfP725w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GneaU4xMj2pRTNi3X+qeo4Hm5D-DJCFL7oHq=BDFfP725w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

On 07/08/2016 08:52 AM, Christophe Varoqui wrote:

> Patches 1 and 2 are merged.
> I commited a patch to delete DIRECTIO and TUR checker_name
> settings to replace patch 3 and 4.

You should also have deleted these lines:
"                .checker_name  = DEFAULT_CHECKER," x3

I will send a path.
