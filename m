From: "bart brooks" <bart_brooks@hotmail.com>
Subject: dm-stripe.c data corruption
Date: Mon, 05 Jun 2006 15:41:25 +0000
Message-ID: <BAY114-F33A29B84D1DB92A33C24C09D940@phx.gbl>
References: <BAY101-F39B1D769666B7AE38961EA9DD10@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BAY101-F39B1D769666B7AE38961EA9DD10@phx.gbl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

In RHEL 4 U3 there’s a bug in dm-stripe.c, in the function stripe_map() 
which will result in data corruption.

The call to the macro below will step on the variable chunk, which is used 
later on in the function.
uint32_t stripe = do_div(chunk, sc->stripes);

The following is a very simple solution:

sector_t chunk2 = chunk;
uint32_t stripe = do_div(chunk2, sc->stripes);

Bart
