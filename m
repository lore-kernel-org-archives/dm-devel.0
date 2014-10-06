From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Reducing size of thin spare metadata, thin metadata
Date: Mon, 6 Oct 2014 09:28:55 +0200
Message-ID: <CAAOsTSmgp892H5M4+XLXSQ-H3G_HFUsnykiyjW+MbP4r7U8+Qw@mail.gmail.com>
Reply-To: patrik@dsl.sk, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

is it possible to (safely) reduce size of thin metadata and / or thin
spare metadata? What size of spare metadata is needed? Can it be
smaller than size of pool metadata?

Thanks.

Patrik
