From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Custom priority callout
Date: Wed, 13 Aug 2008 12:43:13 -0400
Message-ID: <20080813164313.GA27816@mars.virtualiron.com>
References: <A7519D7FDEF2A144BA6D40BDF13100FEF14CB5@ex2.Beer.Town>
	<20080813145159.GB17006@mars.virtualiron.com>
	<A7519D7FDEF2A144BA6D40BDF13100FEF14D7B@ex2.Beer.Town>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A7519D7FDEF2A144BA6D40BDF13100FEF14D7B@ex2.Beer.Town>
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

On Wed, Aug 13, 2008 at 09:57:22AM -0500, Jim Lester wrote:
> Compellent SANs can do a mix of both Fibre connections and iSCSI
> connections to the same volume. So some of our customers are looking for
> ways to do more complex set ups with iSCSI as a failover situation
> behind multiple fibre connections. 

Nice. I would suggest you develop a library implementation and post it
here. This way it could be integrated in all of the Linux distributions
over time and your customers won't have to download a package.

> 
> Multibus works fine if they are using like connections, but if not, we
> wanted to be able to make sure that the faster connections come up on
> top. 

I am curious how you are going to figure this out on the iSCSI connection?
Nop-out latency?
