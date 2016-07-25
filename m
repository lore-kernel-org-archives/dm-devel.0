From: Edward Thornber <thornber@redhat.com>
Subject: Re: dm-cache as a writeback cache that streams all
 writes to cache, and then updates origin
Date: Mon, 25 Jul 2016 10:03:29 -0400
Message-ID: <20160725140329.GB21474@roamer.bos.redhat.com>
References: <CAMOP6rNqF3K2-st5_W+nekUnvghT4oZAWMN9fj9SWhPDTmBR_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAMOP6rNqF3K2-st5_W+nekUnvghT4oZAWMN9fj9SWhPDTmBR_w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gary <admin@garyshood.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 22, 2016 at 06:56:47PM -0700, Gary wrote:
> I understand that dm-cache does not just blindly stream all writes to the
> cache and then update the origin. Is there some way I can enable that
> though (even if it involves changing code)? 

No, sorry.  I really wish I'd called it dm-hotspot.

- Joe
