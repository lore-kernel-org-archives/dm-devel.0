From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: Failing on NIC removal
Date: Tue, 20 Nov 2007 08:16:38 -0600
Message-ID: <342d47870711200616i426656dkeb3e492ee1a5d611@mail.gmail.com>
References: <342d47870711190916x1c3bb959s7e9a45a1312d4701@mail.gmail.com>
	<20071119214601.GB829@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071119214601.GB829@linux.vnet.ibm.com>
Content-Disposition: inline
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

On Nov 19, 2007 3:46 PM, Mike Anderson <andmike@linux.vnet.ibm.com> wrote:
>
> You may need to set ConnFailTimeout to a non-zero value as indicated in
> http://people.redhat.com/mchristi/iscsi/RHEL4/doc/readme
>

Hey Mike,

Sweet, my failover is working perfect now!

Thanks for the help!
Scott
