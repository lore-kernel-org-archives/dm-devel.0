From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: RE: Some issues noticed in my testing.
Date: Sat, 12 Feb 2005 10:40:35 +0100
Message-ID: <420DCF13.3060900@free.fr>
References: <EA4DC661A6353747A2E5C0DE8792DDDE07C16E28@orsmsx404.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <EA4DC661A6353747A2E5C0DE8792DDDE07C16E28@orsmsx404.amr.corp.intel.com>
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

ok merged.

Caushik, Ramesh wrote:

>Sorry for the delay in the response. I am resending the patch. BTW the
>code snippet that you have suggested below does not seem to take care of
>trailing whitespaces in either the vendor or product strings failing the
>match in find_hw. My suggestion is to chomp off trailing ws before doing
>the strcmp. 
>  
>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
