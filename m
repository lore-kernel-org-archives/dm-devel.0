From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: RE: Changes to readsector0
Date: Tue, 8 Jul 2008 17:50:37 -0400
Message-ID: <20080708215037.GA16820@mars.virtualiron.com>
References: <A7519D7FDEF2A144BA6D40BDF13100FE9515C6@ex2.Beer.Town>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A7519D7FDEF2A144BA6D40BDF13100FE9515C6@ex2.Beer.Town>
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

On Tue, Jul 08, 2008 at 02:11:46PM -0500, Jim Lester wrote:
> Is there any reason to use directio over tur if the system supports tur?

No. directio is much slower than tur. Think of tur as 'ping' and directio as
doing a HTTP request - much heavier.
