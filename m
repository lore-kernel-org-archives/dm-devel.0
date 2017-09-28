From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: [PATCH] multipath-tools: replace RDAC maintainer
 with a generic alias
Date: Thu, 28 Sep 2017 21:57:50 +0000
Message-ID: <BFD65D38-32C0-4CE7-B1A0-2BEEDA689505@netapp.com>
References: <20170928214233.9438-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170928214233.9438-1-xose.vazquez@gmail.com>
Content-Language: en-US
Content-ID: <BECF714E6ADBA640B3773A29655886E9@namprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 9/28/17, 4:42 PM, "Xose Vazquez Perez" <xose.vazquez@gmail.com> wrote:

    Sean moved to a different role.
    
    Cc: Sean Stewart <Sean.Stewart@netapp.com>
    Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
    Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
    Cc: device-mapper development <dm-devel@redhat.com>
    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
    ---
     libmultipath/hwtable.c | 4 ++--
     1 file changed, 2 insertions(+), 2 deletions(-)
    
    diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
    index efa81ba..2a93a48 100644
    --- a/libmultipath/hwtable.c
    +++ b/libmultipath/hwtable.c
    @@ -639,8 +639,8 @@ static struct hwentry default_hw[] = {
     		/*
     		 * SANtricity(RDAC) family
     		 *
    -		 * Maintainer : Sean Stewart
    -		 * Mail : sean.stewart@netapp.com
    +		 * Maintainer : NetApp RDAC team
    +		 * Mail : ng-eseries-upstream-maintainers@netapp.com
     		 */
     		.vendor        = "(NETAPP|LSI|ENGENIO)",
     		.product       = "INF-01-00",
    -- 
    2.13.6
    
    
Acked-by: Sean Stewart <Sean.Stewart@netapp.com>
