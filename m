From: malahal@us.ibm.com
Subject: Re: RH 4 and HSG80
Date: Wed, 1 Aug 2007 10:59:46 -0700
Message-ID: <20070801175946.GA28302@us.ibm.com>
References: <46B09E83.9010503@interactivebrokers.com>
	<OFD9DA3C9D.6E99EABB-ONC125732A.005472D4-C125732A.0055D34C@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OFD9DA3C9D.6E99EABB-ONC125732A.005472D4-C125732A.0055D34C@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Bader <Stefan.Bader@de.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Stefan Bader [Stefan.Bader@de.ibm.com] wrote:
> I have no access to HSGs but maybe this generic statements (plus some 
> wisdom from hwtable.c) helps:
> 
> First, you are actually forcing multipath-tools to use all paths by 
> stating "multibus" in you multipath section.
> Everything you put there will replace the defaults and the device 
> sections. Just be minimalistic there. In the

One would expect that whatever is specified in the 'device' section would
be taken for that device no matter what is in the 'defaults' section. If
device section is missing, then it should use from the 'defaults'
section. Why is it implemented to have the 'defaults' section override the
'device' section? Looks odd to me.

Thanks, Malahal.
