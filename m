From: Will Drewry <wad@chromium.org>
Subject: Re: [PATCH] dm: verity target
Date: Thu, 10 Nov 2011 08:42:54 -0600
Message-ID: <CABqD9hZh0yNq5FbC73qhmy3Xa-80ZygSxXAuxbcJEmJqi3K7dw@mail.gmail.com>
References: <1320902290-19050-1-git-send-email-msb@chromium.org>
	<20111110074408.GE10138@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111110074408.GE10138@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Nov 10, 2011 at 1:44 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Wed, Nov 09, 2011 at 09:18:10PM -0800, Mandeep Singh Baines wrote:
>>
>> + * TODO(wad): All hash storage memory is pre-allocated and freed on=
ce an
>> + * entire branch has been verified.
>> + */
>> +struct dm_bht {
>> + =A0 =A0 /* Configured values */
>> + =A0 =A0 int depth; =A0/* Depth of the tree including the root */
>> + =A0 =A0 unsigned int block_count; =A0/* Number of blocks hashed */
>> + =A0 =A0 unsigned int block_size; =A0/* Size of a hash block */
>> + =A0 =A0 char hash_alg[CRYPTO_MAX_ALG_NAME];
>> + =A0 =A0 unsigned char salt[DM_BHT_SALT_SIZE];
>> +
>> + =A0 =A0 /* Computed values */
>> + =A0 =A0 unsigned int node_count; =A0/* Data size (in hashes) for e=
ach entry */
>> + =A0 =A0 unsigned int node_count_shift; =A0/* first bit set - 1 */
>> + =A0 =A0 /* There is one per CPU so that verified can be simultaneo=
us. */
>> + =A0 =A0 struct hash_desc hash_desc[NR_CPUS]; =A0/* Container for t=
he hash alg */
>
> Please don't add a new user for the old hash interface. If the hashes=
 can
> be done asynchronous you can use ahash, if not use shash. Both interf=
aces
> are reentrant, that's probaply what you want to have here. You don't
> need to have this in a per cpu manner.

I'll check out the two interfaces.  I didn't realize hash_desc was
deprecated specifically in favor of one of the others.  I'm interested
in seeing if it is possible to not keep a per-cpu desc though with the
other apis.  We do this now to avoid contention across multiple kernel
threads on crypto operations sharing the hash_desc (e.g., by wrapping
it in a mutex).

Thanks!
