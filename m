From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [multipath-tools][PATCH] two small fixes
Date: Fri, 30 Sep 2005 14:27:02 +0200
Message-ID: <20050930122702.GB29806@free.fr>
References: <OF4AD11055.453B94FF-ONC125708C.003CADFE-C125708C.003D616E@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF4AD11055.453B94FF-ONC125708C.003CADFE-C125708C.003D616E@de.ibm.com>
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

On Fri, Sep 30, 2005 at 01:11:00PM +0200, Stefan Bader wrote:
> Hi,
> 
> two small fixxes:
> 
> 1. I guess 0 _is_ a valid file descriptor though it won't happen very 
> often...
>
ok,
btw, you forgot structs.c:alloc_path()
 
> 
> 
> 2. The status information from path selectors that apply to paths are 
> repeated for
>         each path.
> 
> 
Can you explain this with some example ... I fail to see the logic :/

Regards,
cvaroqui
