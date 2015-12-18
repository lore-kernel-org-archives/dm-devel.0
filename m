From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache selective promotion of block
Date: Fri, 18 Dec 2015 09:46:53 +0000
Message-ID: <20151218094652.GB21956@rh-vpn>
References: <567308D6.8030306@nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <567308D6.8030306@nasa.gov>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Thu, Dec 17, 2015 at 11:11:18AM -0800, Mahmoud Hanafi wrote:
> We are experimenting with dm-cache and would like to be able to
> promote a range of block and pin them in the cache device.
> 
> Are there any tool that can be used for this?

Not at the moment.

Could expand more on why you feel the need for this?  Is this
something you want just for experimentation or would you want to use
it in production?  How do you know which blocks you want to pin?  If
the pinned blocks are in large regions do you actually just want to
build a device that is composed of linear mappings to a mixture of
spindle and ssd devices?

- Joe
