From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: block mapping
Date: Thu, 29 Sep 2011 16:35:44 +0300
Message-ID: <CALLzPKaWVR5=+S7QtHRpPBkDR5SVsZEAhbUn+G09o1S9JhjFOw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello All,

I would like to implement such block device, which can store
additional information along with the block data.
For example. so if file system has 4k block, I would like to store
4k+256b of additional information...

Can such block device be implemented with device mapper?

Thank you,

Dmitry
